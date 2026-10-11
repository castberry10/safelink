# Summative Study Materials

## 1. Participant Onboarding

### 1.1 Consent

### 1.2 Background Introduction

### 1.3 Demographic Collection

> **Gender:**
> - [ ] Male
> - [ ] Female
>
> **Age:** [____] years old

### 1.4 Tutorial

Before entering the main survey items, all participants were explicitly presented with the following definitions to align judgment criteria across respondents. This instruction is central to the study and clarifies that illegal sites which do not impersonate legitimate entities are not considered phishing sites.

> **Criteria for Identifying a Phishing Site**
>
> A **phishing site** is a fake website that impersonates well-known sites, organizations, services, online stores, banks, portals, or login pages, with the intent of **deceiving users into believing it is legitimate and inducing them to enter personal or account information**.
>
> Illegal sites that do not engage in impersonation — such as illegal movie, webtoon, streaming, or download sites — are not phishing sites.
>
> **(Note) Even if a site is malicious, it is NOT a phishing site if it does not impersonate a legitimate entity.**

---

## 2. Stimuli

Ten Warning URLs are used in this study; all are classified as "Warning" by SafeLink. Ground truth is determined by whether each site impersonates a legitimate entity. Items are presented in a randomized order for each participant using a Fisher–Yates shuffle.

### 2.1 Stimulus Set

| No. | URL | Ground Truth | SafeLink Result | Site Characteristics | SafeLink's Explanation |
|---|---|---|---|---|---|
| 1 | hxxps://kalyanpanelchart[.]in/ | Benign | Warning | Indian private gambling results sharing | This site appears to be a private gambling-related website called "Kalyan Panel Chart." Phrases such as "KALYAN PANEL CHART" and "DATE FIX GAME ONLY PAID MEMBER GAME" are visible, and the site appears to share game results. |
| 2 | hxxps://moviesda4[.]co/ | Benign | Warning | Illegal Tamil movie download site | This site, named "Moviesda," promotes itself as a place to download Tamil movies. While phrases like "Download Now" are visible, illegal download sites like this can expose users to malware or redirect them to dangerous pages, so caution is advised. |
| 3 | hxxps://lit[.]link/en/linetogel89 | Benign | Warning | Gambling site promotion via link aggregator (lit.link) | This site uses "lit.link," a service that aggregates multiple links into one page. However, this particular page is used to promote and link to an online gambling site called "Linetogel." Phrases such as "bandar judi togel online indonesia terpercaya" are visible. |
| 4 | hxxps://www[.]filmyzilla[.]com[.]ec/ | Benign | Warning | Illegal movie/TV show download site | This site, named "Filmyzilla," advertises free downloads of movies and TV shows. It is likely to offer copyright-infringing content and may link to malicious advertisements or software downloads, so caution is needed. |
| 5 | hxxps://www[.]gudanglagu456[.]cc/ | Benign | Warning | Illegal free music download site | This site, "Gudanglagu456.cc," is a free music download site. Phrases such as "Download Lagu Mp3," "Gudang Download Lagu MP3 Terbaru Gratis 2023," and "Download Lagu Terbaik 2023" are visible. |
| 6 | hxxps://almirakelinka[.]kz/ | Phishing | Warning | Telegram channel subscription lure (brand impersonation for traffic collection) | This site encourages users to join a Telegram channel, using the phrase "Қарапайым келін" and a "Join Channel" button to attract specific users. This appears to be a potential phishing attempt. |
| 7 | hxxps://arv-1myweb[.]dyndns[.]org/personal/logon | Phishing | Warning | Arvest Bank impersonation (credential harvesting) | This site uses a dynamic DNS service address, "dyndns.org," and appears to impersonate "Arvest Bank," though it is not the actual bank's website. Fields for entering "Login ID" and "Login Password" are visible. |
| 8 | hxxps://attservivnidip343[.]weeblysite[.]com/ | Phishing | Warning | AT&T impersonation (free hosting + typosquatting) | This site is hosted on a free website creation service, weeblysite.com, and uses the word "att" to impersonate AT&T. This is not the real AT&T website, so caution is advised. |
| 9 | hxxps://craftbeerbox[.]com/wromi7g52lx8[.]html | Phishing | Warning | Steam impersonation (domain–content mismatch) | While the site appears to be related to craft beer, its actual content resembles the "Steam" gaming platform. Phrases such as "STORE," "COMMUNITY," and "Install Steam" are visible, and the discrepancy between the domain and content is suspicious. |
| 10 | hxxps://smithsonvalleyservices[.]com/securemail/ | Phishing | Warning | Email security disguise (under-construction page) | This site uses the domain "smithsonvalleyservices.com" and displays the word "Protected." The website may still be under construction or in the process of integrating with another service. |

### 2.2 Response Format

Each item page displays a stimulus image (a screenshot of the SafeLink result screen), followed by two response fields.

> **Item i / 10**
>
> *Please respond based on the explanation and URL shown in the image.*
>
> [Stimulus image: SafeLink Warning result screen with explanation]
>
> **Do you think this is a phishing site?** ※ Required
> - [ ] Yes
> - [ ] No
>
> **Please explain your reasoning.** ※ Required
> *Please provide as much detail as possible. Describe which part of the explanation you focused on and how it led you to judge whether or not the site is a phishing site.*
> [Text box]

### 2.3 Procedure

Participants respond to one item per page in sequence and may return to a previous page to revise their responses. Both responses (binary choice + open-ended justification) must be completed before proceeding to the next page. A progress bar displays the current position (e.g., 5 / 12).