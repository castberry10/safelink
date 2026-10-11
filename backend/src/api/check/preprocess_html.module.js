import parse from 'html-dom-parser';

const EVENT_ATTRS = ['onsubmit', 'onclick', 'onchange', 'onload', 'onmouseover'];
const KEEP_ATTRS = new Set([
  "href", "src", "action", "method", "formaction", "formenctype",
  "type", "name", "value", "autocomplete", "placeholder", "maxlength",
  "onclick", "onchange", "onsubmit", "onload", "onmouseover",
  "content", "http-equiv", "charset", "alt", "title", ...EVENT_ATTRS
]);
const AD_KEYWORDS = [
  "ad", "ads", "adsbygoogle", "adsense", "adbox", "adunit", "adslot",
  "advert", "advertisement", "banner", "sponsor", "sponsored", "promo",
  "promote", "promotion", "doubleclick", "googlesyndication", "gpt-ad",
  "google_ad", "dfp-ad", "yahooad", "taboola", "outbrain"
];
const SUSPICIOUS_PATTERNS = [
  { pattern: 'fetch_post', regex: /fetch\s*\(([^)]*?method\s*:\s*['"]post['"][^)]*)\)/gi },
  { pattern: 'sendBeacon', regex: /navigator\.sendBeacon\s*\([^)]*\)/gi },
  { pattern: 'setInterval', regex: /setInterval\s*\([^)]*\)/gi },
  { pattern: 'document.write', regex: /document\.write\s*\([^)]*\)/gi },
  { pattern: 'addEventListener', regex: /addEventListener\s*\(\s*['"](copy|click|keydown)['"][^)]*\)/gi },
  { pattern: 'clipboard.readText', regex: /navigator\.clipboard\.readText\s*\([^)]*\)/gi },
  { pattern: 'eval', regex: /eval\s*\([^)]*\)/gi }
];
const AD_RE = new RegExp(`(?:^|[^a-z0-9])(?:${AD_KEYWORDS.map(k => k.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')).join('|')})\\d*(?:[^a-z0-9]|$)`, 'i');

/**
 * @param {*} element 
 * @returns 
 */
const shouldSkip = (element) => {
  let isAdElement = false;
  const tagName = element.tagName.toLowerCase();
  if (['script', 'iframe', 'ins', 'div', 'section', 'span'].includes(tagName)) {
    const attrs = Array.from(element.attributes).map(attr => attr.value).join(' ');
    isAdElement = AD_RE.test(attrs);
  }
  return tagName === 'style' || isAdElement;
}

/**
 * @param {*} elem 
 * @param {*} fnNames 
 * @returns 
 */
const getAttrs = (elem, fnNames) => {
  const attrs = {};
  if (elem.attribs) {
    for (const [key, value] of Object.entries(elem.attribs)) {
      if (KEEP_ATTRS.has(key)) {
        attrs[key] = value;
        if (EVENT_ATTRS.includes(key)) {
          const foundFn = value.match(/([a-zA-Z-1-9_]+)\s*\(/g) || [];
          foundFn.forEach(fnCall => fnNames.add(fnCall.replace(/\(.*/, '')));
        }
      }
    }
  }
  return attrs;
}

/**
 * @param {*} elem 
 * @param {*} fnNames 
 */
const getChildren = (elem, fnNames, ctx) => {
    const children = {};
    if (elem.children) {
        for (const child of elem.children) {
            let obj;
            if (child.type === 'tag') {
                if (shouldSkip(child)) continue;
                obj = elementToObj(child, fnNames, ctx);
            } else if (child.type === 'text') {
                const txt = child.data.replace(/\s+/g, ' ').trim();
                if(txt.length === 0) continue;
                if (ctx && typeof ctx.foundedTextCount === 'number') ctx.foundedTextCount += 1;
                obj = { key: '#text', value: txt };
            }

            if (obj !== null && obj !== undefined) {
              const { key, value } = obj;
              if( value === null || value === undefined) continue;
              if (children[key]) {
                  if (!Array.isArray(children[key])) {
                      children[key] = [children[key]];
                  }
                  children[key].push(value);
              } else {
                  children[key] = value;
              }
            }
        }
    }

    if (children['#text']) {
        if (Array.isArray(children['#text'])) {
            children['#text'] = children['#text'].join(' ');
        }
        if (children['#text'].length > 350) {
          children['#text'] = children['#text'].slice(0, 350) + '...';
        }
    }

    return children;
}

/**
 * @param {*} elem HTML object
 * @param {*} fnNames function set
 * @returns 
 */
const elementToObj = (elem, fnNames, ctx) => {
    const attrs = getAttrs(elem, fnNames);
    const children = getChildren(elem, fnNames, ctx);
    const tagName = elem.name ? elem.name.toLowerCase() : 'idk';

    const nodes = {};

    if (Object.keys(attrs).length > 0) {
        nodes['@attrs'] = attrs;
    }
    if (Object.keys(children).length > 0) {
        nodes['children'] = children;
    }
    if (!nodes['@attrs'] && Object.keys(children).length === 1) {
        const key = Object.keys(children)[0];
        return { key, value: children[key] };
    }

    return { key: tagName, value: Object.keys(nodes).length > 0 ? nodes : null };
}

/**
 * @param {*} fnNames 
 */
const extractSuspiciousCodes = (fnNames, htmlString) => {
  let allScripts = [];
  const scriptRe = /<script[^>]*>([\s\S]*?)<\/script>/gi;
  let match;
  while ((match = scriptRe.exec(htmlString)) !== null) {
    allScripts.push(match[1].trim());
  }
  allScripts = allScripts.join('\n');

  const functionDetails = [];
  fnNames.forEach(fnName => {
    const fnRegex = new RegExp(`function\\s+${fnName}\\s*\\([^)]*\\)\\s*{[\\s\\S]*?}`);
    const matchFn = allScripts.match(fnRegex);
    if (matchFn) {
      functionDetails.push({ fnName, code: matchFn[0] });
    } else {
      const arrowFnRegex = new RegExp(`${fnName}\\s*=\\s*\\([^)]*\\)\\s*=>\\s*{[\\s\\S]*?}`);
      const matchArrow = allScripts.match(arrowFnRegex);
      if (matchArrow) {
        functionDetails.push({ fnName, code: matchArrow[0] });
      }
    }
  });

  const SAMPLE_LENGTH = 300;
  SUSPICIOUS_PATTERNS.forEach(({ pattern, regex }) => {
    let match;
    while ((match = regex.exec(allScripts)) !== null) {
      const startIdx = match.index;
      const codeSample = allScripts.substring(startIdx, startIdx + SAMPLE_LENGTH);
      functionDetails.push({ pattern, codeSample });
    }
  });

  return functionDetails;
}

/**
 * @param {*} htmlString HTML string
 * @returns 
 */
export const htmlToJson = (htmlString) => {
    const root = parse(htmlString);
    const ctx = { foundedTextCount: 0 };

    const tree = {};
    const fnNames = new Set();
    for (const child of root) {
        if (child.type === 'tag' && !shouldSkip(child)) {
            const obj = elementToObj(child, fnNames, ctx);
            if (obj === null) continue;
            const key = child.name.toLowerCase();
            if (tree[key]) {
                if (!Array.isArray(tree[key])) {
                    tree[key] = [tree[key]];
                }
                tree[key].push(obj);
            } else {
                tree[key] = obj;
            }
        }
    }

    tree['script'] = extractSuspiciousCodes(fnNames, htmlString);
    return {tree, foundedTextCount: ctx.foundedTextCount};
}

const decodeUnicode = str => str.replace(/\\u([0-9a-fA-F]{4})/g, (m, g1) => String.fromCharCode(parseInt(g1, 16)));

export const verifyHtmlContent = (htmlContent) => {
    htmlContent = htmlContent.trim();
    htmlContent = decodeUnicode(htmlContent);

    const sample = (htmlContent || '').slice(0, 100);
    if (!sample) return;
    let nonPrintable = 0;
    for (let i = 0; i < sample.length; i++) {
        const code = sample.charCodeAt(i);
        if ((code <= 31 && code !== 9 && code !== 10 && code !== 13) || code === 0xFFFD) nonPrintable++;
    }
    const ratio = nonPrintable / sample.length;
    if (ratio >= 0.25) {
      htmlContent = null;
    }
    return htmlContent;
}

