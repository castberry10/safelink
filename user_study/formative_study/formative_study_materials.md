# Formative Study Materials
## 1. Participant Onboarding

### 1.1 Consent

### 1.2 Background Introduction

### 1.3 Demographic Collection

> **Year of birth:** [\____ year]
>
> **Gender:**
> - [ ] Male
> - [ ] Female
>

### 1.4 Pre-question
> **1. I have experience scanning QR codes on typical flyers found in public places.**
> - [ ] Yes
> - [ ] No
>
> **2. I have encountered or been aware of cases related to phishing, scams, or malicious websites through QR codes, even if I was not personally affected.**
> - [ ] Yes
> - [ ] No
>
> **3. I believe I have enough knowledge to judge, to some extent, whether a website may be a phishing site based only on its domain address.**
> - [ ] Yes
> - [ ] No

### 1.5 Tutorial

---

## 2. QR code Evaluation

Each participant is presented with 16 QR codes in a random order. The procedure for each trial is as follows. (1) The participant scans the QR code using a Galaxy S25 device. (2) SafeLink is activated and presents a result screen indicating Safe, Warning, or Danger, along with an explanation. (3) After carefully reviewing the screen, the participant responds to the statement “I think this QR code is safe” on a 7-point Likert scale (1 = Strongly disagree, 7 = Strongly agree). (4) The participant decides whether to actually visit the site (Proceed) or block it (Block).

### 2.1 Stimuli

This study presents 16 URLs selected from the TR-OP benchmark dataset in the form of QR codes. Based on SafeLink’s classification results, the stimuli are organized across four categories in a balanced manner, while the “Warning” category is intentionally oversampled to observe how users handle uncertainty.

### 2.2 Stimulus Set

URLs are defanged for safety.

| No. | URL | Ground Truth | SafeLink Result | SafeLink's Explanation |
|---:|---|---|---|---|
| QR1 | hxxps://10fastfingers[.]com/ | Benign | Safe | This website is “10fastfingers.com,” which is a legitimate site for typing practice and speed measurement. It appears to be a safe place for typing tests or competitions. |
| QR2 | hxxps://americanaddictioncenters[.]org/ | Benign | Safe | This website is the official site of an actual addiction treatment center called "American Addiction Centers." The address is real, and the content has lots of information about addiction treatment, so it looks safe. Feel free to browse with peace of mind. |
| QR3 | hxxps://apha[.]org/ | Benign | Safe | This website (apha.org) is the official site of the American Public Health Association. The content is genuine and safe, so you can use it without concern. |
| QR4 | hxxps://vs3[.]com/ | Benign | Safe | This page appears to be a website that helps with billing-related inquiries for VS3.com. It is a place where you can enter information to receive help when you have questions about credit card billing details. Although it requests personal information, it does not appear to be a phishing site attempting to steal information through deception. |
| QR5 | hxxps://www[.]modapkdown[.]com/ | Benign | Warning | This website encourages downloading modified games or apps from places that are not official app stores. Such files may hide malicious code, which can damage your phone or steal personal information, so it is very dangerous. |
| QR6 | hxxps://www[.]movies-watch[.]com[.]pk/ | Benign | Warning | This website is a place that allows you to watch or download the latest movies for free illegally. It does not directly steal personal information, but it is an illegal site that violates copyright. |
| QR7 | hxxps://www[.]ofilmywap[.]expert/ | Benign | Warning | This website provides illegal movies. It is not a direct phishing site, but such places usually have many advertisements or viruses, so they are dangerous. Although it is not phishing fraud, you may be exposed to other risks. |
| QR8 | hxxps://www[.]on455[.]com/ | Benign | Warning | This website promotes an online gambling game called “Togglelon.” Gambling itself is not phishing, but fake gambling sites disguised to look real often steal personal information or take money. This site’s address also looks different from commonly known gambling sites, and many other links are connected in a complicated way, so it is better to be cautious. |
| QR9 | hxxps://sky-104385[.]weeblysite[.]com/ | Phishing | Warning | This website was created using a free website creation tool called “Weebly.” It may pretend to be a famous brand called “Sky,” so caution is needed. You should be careful if an unfamiliar site asks for personal information. |
| QR10 | hxxps://pancake-frontend-dejmy38ut-chefilip[.]vercel[.]app/pottery | Phishing | Warning | This website address looks fine at first glance, but it is suspicious because it is different from the actual PancakeSwap address. It is important to always check whether it is the real address before entering personal information or connecting your wallet. Otherwise, you may lose money. |
| QR11 | hxxps://wana78420[.]myfreesites[.]net/ | Phishing | Warning | This website address is using a free website creation service. Such free services are often used by bad actors to create fake sites, so you should be cautious. It does not appear dangerous right now, but since you do not know what content may appear later, it is better to be careful. |
| QR12 | hxxp://navaer[.]c1[.]biz/?naps | Phishing | Warning | This website address (navaer.c1.biz) is somewhat strange. Uncommon addresses like “c1.biz” are often used by scammers to create fake sites. It does not request personal information yet, but its purpose is unclear and there are many suspicious aspects, so you should be careful. Do not click unknown links. |
| QR13 | hxxp://zanetwork[.]com/?gclid=EAIaIQobChMI6uTJ2pGogAMVTk0NCh0kkw9YEAEYASAAEgIWT_D_BwE | Phishing | Danger | This page shows fake security scan results while warning as if your computer is infected with a serious virus. It impersonates Microsoft and induces you to call a specific number, but you should never call it! It is a scam method that steals personal information or demands money. |
| QR14 | hxxps://bridgestone-onmicrosoft[.]com/?rid=OgoqBxp | Phishing | Danger | This page looks like a Microsoft login screen, but the address is not the actual Microsoft website. In reality, it is hidden to send information elsewhere, so if you enter your ID and password, your personal information may be at risk. |
| QR15 | hxxp://203[.]159[.]154[.]241/moodle_data/environment/snt/information[.]php/ | Phishing | Danger | This website looks like an Outlook login page, but the address is not the official Outlook address. It also requests a lot of personal information such as your date of birth and address, so you should be careful. It is highly likely to be a phishing site attempting to steal personal information. |
| QR16 | hxxps://videoawake01[.]online/ | Phishing | Danger | This site promotes “VIP video” and induces you to join Telegram. The address is also suspicious, and it is a typical phishing site that may cause harm by requesting personal information or making you download suspicious files. |

---

## 3. Post-Study Questionnaire

This post-study questionnaire consists of 11 items across 4 constructs. All items are measured on a 7-point Likert scale (1 = Strongly disagree, 7 = Strongly agree).

### 3.1 Usefulness

> **Q1.** SafeLink’s feedback helped me decide what to do (proceed vs. avoid) when encountering suspicious links.
>
> **Q2.** Using SafeLink made the process of evaluating link safety feel easier.

### 3.2 Explainability

> **Q3.**  I could understand why SafeLink showed its result (Safe / Warning / Danger) based on the feedback provided.
>
> **Q4.** The explanation provided in the Warning outcome was sufficient to help me decide whether to proceed.
>
> **Q5.** The explanations were helpful in judging the risk level of the links.
>
> **Q6.** Having a Warning outcome, rather than only Safe or Danger, made the system feel more reliable.

### 3.3 Trust and Control

> **Q7.**  I trusted SafeLink’s risk assessment (Safe / Warning / Danger).
>
> **Q8.** Even when SafeLink provided warnings, I felt that the final decision remained under my control.
>
> **Q9.** After seeing SafeLink’s feedback, I felt more confident about my decision regarding the link.

### 3.4 Intention to Use

> **Q10.** If available on my smartphone, I would be willing to use SafeLink in everyday situations.
>
> **Q11.**  Having SafeLink would reduce my anxiety when encountering unfamiliar links.

> **Response Options:**
> - [ ] Strongly disagree (1)
> - [ ] Disagree (2)
> - [ ] Slightly disagree (3)
> - [ ] Neutral (4)
> - [ ] Slightly agree (5)
> - [ ] Agree (6)
> - [ ] Strongly agree (7)

---

## 4. Semi-Structured Interview

### 4.1 Interview Format

For each of the 11 Likert-scale items in the post-study questionnaire, participants are asked to freely explain the reason for the score they assigned. Follow-up questions for each item follow the general format below:

> “You just gave Q[n] a score of [score]. Could you freely explain why you rated it that way? If you did not give it a full score, we would also appreciate it if you could share what aspects you felt were lacking.”

### 4.2 Overall Interview Questions

After participants complete their responses to the 11 items, the following overall question is used to summarize their entire user experience:

> “What was your overall impression after using SafeLink today? Please feel free to share anything, including what you particularly liked, what you found disappointing, who you would recommend it to if it were actually released, and what aspects you think should be improved. Also, if it were actually released, please let us know how much you would be willing to pay as a monthly subscription fee.”