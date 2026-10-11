import fs from 'fs';
import { GoogleGenAI } from '@google/genai';
import { htmlToJson, verifyHtmlContent } from './preprocess_html.module.js';

const GEMINI_API_KEY = process.env.GEMINI_API_KEY;
const safelink_prompt = JSON.parse(fs.readFileSync(new URL('./safelink_prompt.json', import.meta.url), 'utf-8'));

const analysisWithGemini = async (resolvedHost, textContent) => {
    const ai = new GoogleGenAI({apiKey: GEMINI_API_KEY});
    const systemPrompt = safelink_prompt.system['for-public'];
    const instruction = safelink_prompt.user['instruction'];
    const outputFormat = safelink_prompt.user['output-format'];

    return await ai.models.generateContent({
        model: 'gemini-2.5-flash',
        contents: `${instruction['before-url']}${resolvedHost}
                    ${instruction['before-html']}${textContent}
                    ${instruction['after-html']}`,
        config: {
            systemInstruction: systemPrompt,
            responseMimeType: 'application/json',
            responseSchema: outputFormat,
            thinkingConfig: {
                thinkingBudget: 0,
            }
        }
    })
}

export const checkPageContent = async (urlInfo, htmlContent) => {
    htmlContent = verifyHtmlContent(htmlContent);
    let doReCrawl = false;
    let compressedHtmlContent = null;
    let tree;
    if (htmlContent === null || typeof htmlContent !== 'string') {
        htmlContent = null;
        doReCrawl = true;
    } else {
        let tmp = htmlToJson(htmlContent);
        tree = tmp.tree;
        if (tmp.foundedTextCount < 1) {
            doReCrawl = true;
        }
    }

    if(doReCrawl) {
        if (htmlContent == null){
            tree = {"failToCrawling": "Crawling failed. Possible server error or invalid URL format."}
        } else {
            tree["comment"] = "The page contains very little text content. Possible reasons include heavy use of images, videos, or scripts.";
        }
    }

    compressedHtmlContent = JSON.stringify(tree).slice(0, 1500000);

    try {
        const res = await analysisWithGemini(urlInfo.resolvedHost, compressedHtmlContent);
        if(!res.candidates){
            return {
                data: { "result": 3, "threatMsg": "AI analysis failed. This page may be harmful." },
                cacheable: false,
            };
        }
        const jsonObj = JSON.parse(res.candidates[0].content.parts[0].text);
        if (jsonObj.is_phishing < 1 || jsonObj.is_phishing > 3)
            throw new Error("Invalid is_phishing value from AI analysis");
        return {
            data: { "result": jsonObj.is_phishing, "threatMsg": jsonObj.user_friendly_explanation || "The page has been flagged as suspicious." },
            cacheable: true,
        };
    } catch (error) {
        console.error("Error during AI analysis:", error);
        return {
            data: { "result": 2, "threatMsg": "AI analysis failed. Please try again." },
            cacheable: false,
        };
    }
}