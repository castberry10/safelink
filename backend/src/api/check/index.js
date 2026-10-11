import express from 'express';
import parseUrl from '../parse_url.middleware.js';
import { checkPageContent } from './check.service.js';
import crypto from 'crypto';
import prisma from '../../db.js';

const check = express.Router();

function hashSHA256(message) {
  return crypto.createHash("sha256").update(message).digest("hex");
}

check.get('/page-content', parseUrl, async (req, res) => {
    let websiteUrl = req.query.websiteUrl ?? req.body.websiteUrl;
    let htmlContent = req.htmlContent ?? "";
    if (!websiteUrl)
        return res.status(400).json({ message: 'websiteUrl is required' });
    if (websiteUrl[0] === '"' || websiteUrl[0] === "'")
        websiteUrl = websiteUrl.slice(1, -1);
    let websiteUrlcode = hashSHA256(websiteUrl);
    let htmlContentcode = hashSHA256(htmlContent);

    try {
        const cached = await prisma.cache.findUnique({
            where: { urlHash: websiteUrlcode }
        });

        if (cached) {
            if (cached.htmlHash === htmlContentcode) {
                return res.status(200).json({ ...cached.data});
            } else {
                const { data, cacheable } = await checkPageContent(req.urlInfo, htmlContent);
                if (!cacheable)
                    return res.status(200).json({ ...data });
                const updated = await prisma.cache.update({
                where: { urlHash: websiteUrlcode },
                data: { htmlHash: htmlContentcode, data }
                });
                return res.status(200).json({ ...updated.data });
            }
        } else {
            const { data, cacheable } = await checkPageContent(req.urlInfo, htmlContent);
            if (!cacheable)
                return res.status(200).json({ ...data });
            const created = await prisma.cache.create({
                data: { urlHash: websiteUrlcode, htmlHash: htmlContentcode, data }
            });
            return res.status(200).json({ ...created.data });
        }
    } catch (error) {
        console.error(error);
        return res.status(500).json({ message: 'Server Error' });
    }
});

export default check;