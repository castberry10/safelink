import { URL } from 'url';
import psl from 'psl';
import http from 'http';
import https from 'https';

const MAX_REDIRECTS = 20;
const AGENT_TYPE = "mobile";

const resolveTarget = (target, baseUrl) => {
    try {
        const resolved = new URL(target, baseUrl);
        return /^https?:$/i.test(resolved.protocol) ? resolved.toString() : null;
    } catch {
        return null;
    }
};

const findClientRedirect = (html) => {
    const jsRedirect = html.match(/window\.location\.replace\(['"]([^'"]+)['"]\)/i);
    if (jsRedirect) return jsRedirect[1];

    const renderedHtml = html.replace(/<noscript[\s\S]*?<\/noscript>/gi, '');
    const metaTags = renderedHtml.match(/<meta\b[^>]*>/gi) || [];
    for (const tag of metaTags) {
        if (!/http-equiv\s*=\s*["']?\s*refresh/i.test(tag)) continue;
        const target = tag.match(/content\s*=\s*["']?\s*[\d.]*\s*[;,]\s*url\s*=\s*['"]?([^'"\s>]+)/i);
        if (target) return target[1].replace(/&amp;/gi, '&');
    }
    return null;
};

const getOriginalUrlNContent = async (inputUrl) => {
    return new Promise((resolve, reject) => {
        const visited = new Set();
        let redirects = 0;
        const fetch = (url) => {
            visited.add(url);
            const follow = (target) => {
                if (!target || redirects >= MAX_REDIRECTS) return false;
                const nextUrl = resolveTarget(target, url);
                if (!nextUrl || visited.has(nextUrl)) return false;
                redirects++;
                fetch(nextUrl);
                return true;
            };
            const lib = url.startsWith('https') ? https : http;
            const options = {
                headers: {
                    'User-Agent': AGENT_TYPE === 'mobile' ?
                        'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Mobile Safari/537.36' :
                        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36',
                    'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8',
                    'Accept-Language': 'en-US,en;q=0.9',
                }
            };
            const req = lib.get(url, options, (res) => {
                if (res.statusCode >= 300 && res.statusCode < 400 && follow(res.headers.location)) {
                    res.resume();
                    return;
                }
                let data = '';
                res.on('data', chunk => data += chunk);
                res.on('end', () => {
                    if (follow(findClientRedirect(data))) return;
                    resolve({
                        rawWebsiteUrl: url,
                        html: data,
                        redirectCount: redirects,
                    });
                });
            });
            req.on('timeout', () => {
                req.destroy(new Error('Request timed out'));
            });
            req.on('error', (err) => reject(err));
            req.setTimeout(3000, () => {
                req.destroy();
                reject(new Error('Request timed out'));
            });
        };
        fetch(inputUrl);
    });
};



const urlAnalysisMiddleware = async (req, res, next) => {
    let websiteUrl = req.query.websiteUrl ?? req.body.websiteUrl;
    if (!websiteUrl)
        return res.status(400).json({ message: 'websiteUrl is required' });

    try {
        if (websiteUrl[0] === '"' || websiteUrl[0] === "'")
            websiteUrl = websiteUrl.slice(1, -1);

        const parsedUrl = new URL(websiteUrl);
        const parsedDomain = psl.parse(parsedUrl.hostname);
        if (!parsedDomain.domain) {
            return res.status(400).json({ message: 'Invalid URL domain' });
        }

        await getOriginalUrlNContent(websiteUrl)
            .then(({ rawWebsiteUrl, html, redirectCount }) => {
                req.rawWebsiteUrl = rawWebsiteUrl;
                req.htmlContent = html;
                req.redirectCount = redirectCount;
            })
            .catch(() => {
                req.geturlfail = true;
                req.rawWebsiteUrl = websiteUrl;
            });

        req.urlInfo = {
            protocol: parsedUrl.protocol,
            domain: parsedDomain.domain,
            subdomain: parsedDomain.subdomain,
            resolvedHost: new URL(req.rawWebsiteUrl).hostname,
        };

        next();
    } catch (error) {
        return res.status(400).json({ message: error.message });
    }
};

export default urlAnalysisMiddleware;