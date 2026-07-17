---
description: |
  Guide and best practices for App Store Connect metadata localization, translation workflows, keyword optimization, and addressing naming/version state constraints during App Store Connect API/MCP tool execution.
when_to_use: |
  When preparing metadata for App Store Connect, translating App Store descriptions/keywords, resolving naming conflicts (DUPLICATE_NAME), configuring first-version constraints (whatsNew state errors), or performing localization operations using MCP tools.
name: appstoreconnect-translation
---

# App Store Connect Translation & Localization Best Practices

Metadata localization is one of the most critical steps for driving international user acquisition, boosting App Store Optimization (ASO) rankings, and improving conversion rates (CVR). When configuring localized metadata in App Store Connect, you must adhere to Apple's rigid constraints and specific business logic.

---

## 🌐 Golden Rule: Primary Locale Parity

> **Every field populated in the primary locale MUST also be populated in every other configured locale.**

This rule applies universally across all localization layers:

| Localization Layer | Scope |
|---|---|
| App Store Version Localization | `description`, `keywords`, `whatsNew` (non-v1.0), `supportUrl`, `marketingUrl` |
| App Info Localization | `name`, `subtitle`, `privacyPolicyUrl`, `privacyChoicesUrl` |
| In-App Purchase / Subscription Localization | `name`, `description` |
| Beta Build Localization | `whatsNew` (TestFlight notes) |

**Why this matters:**
- Leaving a field blank in a secondary locale causes Apple to **fall back to the primary locale value**, which may be in the wrong language for that market — harming user trust and store conversion.
- For mandatory fields like `supportUrl`, an empty value in any locale can trigger an **App Review rejection**.
- Incomplete localizations are a leading cause of **inconsistent App Store pages** across regions.

**Operational Rule for MCP Tool Execution:**
Before completing any localization task, always verify that every field set in the primary locale has a corresponding value in all target locales. If the user has not provided locale-specific content for a given field, **default to carrying over the primary locale value verbatim** rather than leaving the field empty. Prompt the user only when a field genuinely requires locale-specific adaptation (e.g., translated descriptions, region-specific URLs).

---

## 1. Core Metadata Localization Guide

### A. App Store Version Metadata (App Store Version Localization)
* **App Description (Description)**
  * **Length Limit**: Maximum 4,000 characters.
  * **Formatting Principle**: Keep the first 2-3 lines highly engaging and clear, as this is the "above the fold" content shown before the "More" toggle. Use lists or emojis to partition key features and value propositions.
* **Search Keywords (Keywords)**
  * **Length Limit**: Maximum 100 characters (including separators).
  * **Separator Rule**: Use **half-width commas (`,`) without spaces**. Spaces consume characters and cause indexing issues.
  * **ASO Optimization**: Consolidate functional keywords, synonyms, and category terms. Combine them to fill 90–99 characters to maximize your indexing potential.
  * **⚠️ Translation Keyword Rule**: After translating keywords to a target language, **always count the resulting character length**. Translated keywords are almost always shorter than the primary locale due to CJK character density differences. You MUST expand the keyword list with additional synonyms, use-case terms, and long-tail phrases to reach 90–99 characters. **Never submit translated keywords below 80 characters — this wastes indexing slots and directly harms ASO rankings in that market.**
* **First-Version Constraint (v1.0 / Prepare For Submission)**
  * **⚠️ Crucial Trap**: If the App Store version is the **very first release (v1.0)**, the **`whatsNew` (What's New in This Version) parameter MUST be set to `nil` (empty)** during creation or update.
  * **Reason**: Since a first version has no previous version to compare to, Apple's API does not allow release notes. Passing text to this field will result in a `409 STATE_ERROR - Attribute 'whatsNew' cannot be edited at this time` API rejection. This field is only allowed for subsequent app updates (v1.1, v2.0, etc.).
* **Support URL (supportUrl)**
  * **Required**: Mandatory for all App Store versions; omitting it will cause submission rejection. Must be a fully qualified `https://` or `http://` URL.
* **Marketing URL (marketingUrl)**
  * **Optional**: Fully qualified `https://` or `http://` URL. Leave empty if not applicable.

---

## 2. App Info Localization (App Info Localization)

### A. Resolving Duplicate App Name Conflicts (DUPLICATE_NAME)
* **Issue**: When creating a new localization language (e.g., `zh-Hans`), if it defaults to inheriting the primary app name (e.g., `"ReadOne"`), it will throw a conflict error if that name is already registered by another developer in that region:
  `409 STATE_ERROR.DUPLICATE_NAME.DIFFERENT_ACCOUNT: Cannot add localization due to app name...`
* **Solution**:
  When calling `create_app_info_localization`, **you must explicitly provide a unique local name** (e.g., `"ReadOne Reader"` or `"ReadOne Pro"`) to separate it from the primary name. This will bypass the duplicate name detection and allow the localization page to compile successfully.
* **App Subtitle (Subtitle)**
  * **Length Limit**: Maximum 30 characters.
  * **Best Practice**: Don't repeat the app name. Describe the app's utility concisely with a call-to-action (e.g., "Minimalist RSS Feed Reader") to improve search ranking and conversion.

---

## 3. Test Information Localization (Beta Build Localization)

* **WhatsNew (TestFlight Release Notes)**
  * Use `update_build_testing_info` to localize the "What to Test" notes for TestFlight testers in different locales. This ensures external beta testers receive testing instructions in their native language, drastically improving feed accuracy.

---

## 4. In-App Purchase & Subscription Localization

* **Paywall Synchronization**:
  After adding a new store localization, ensure you also configure localizations using `create_iap_localization` or `create_subscription_localization`. Failing to do so will display the primary language (e.g., English) on the purchase sheet for international users, which decreases purchase conversion.

---

## 5. Standard Localization Workflow (End-to-End)

Follow this five-phase workflow whenever the user asks to add or update App Store metadata for one or more locales.

---

### Phase 0 — Confirm Target Platforms

**Before asking about languages, determine which platforms the app has.**

1. Call `list_app_store_versions` for the app to retrieve all App Store versions.
2. Group results by `platform` attribute. Possible values: `IOS`, `MAC_OS`, `VISION_OS`.
3. Present the platforms found and ask the user which ones to include:

```
This app has App Store versions on the following platforms:
- iOS
- macOS
- visionOS

Which platforms should the localization apply to?
```

**Wait for user confirmation before proceeding.**

> **Note**: App Info localization (`name`, `subtitle`, `privacyPolicyUrl`) is shared across all platforms — it only needs to be created/updated once. App Store Version localization (`description`, `keywords`, `supportUrl`, etc.) must be applied **separately to each selected platform's version**.

---

### Phase 1 — Confirm Target Languages

**Ask the user which language(s) to localize.**

Recommend languages using this priority order:
1. **App's supported UI languages** — check the app's existing localizations first (via `list_app_store_versions` / `list_app_info_localizations`). Suggest any UI language that does not yet have store metadata.
2. **Fallback: Top App Store markets** (use this list if the app has no multi-language UI):
   `en-US`, `zh-Hans`, `zh-Hant`, `ja`, `ko`, `es-MX`, `fr-FR`, `de-DE`, `pt-BR`, `ar-SA`

Present the recommendation clearly and wait for user confirmation before proceeding.

---

### Phase 2 — Collect Data & Present Plan

**For each confirmed target language:**

1. **Fetch primary locale data** — retrieve all fields from the primary locale (App Info + App Store Version localizations for each target platform).
2. **Check if target locale exists** — call `list_app_info_localizations` and `list_app_store_version_localizations` (per platform):
   - **Does not exist** → will `create` new localization.
   - **Already exists** → will `update` existing localization (patch only changed fields).
3. **Auto-translate** — translate the primary locale content into the target language. Apply locale-specific adaptations where needed (e.g., region-specific URLs, keyword localization).
4. **Present a review table** for each target locale before executing anything:

```
## Localization Plan — [Target Locale]  (Action: CREATE / UPDATE)

### App Info (shared across all platforms)
| Field           | Primary Locale (en-US) value | Planned value for [locale] |
|-----------------|------------------------------|---------------------------|
| name            | MyApp                        | MyApp                     |
| subtitle        | Your smart reader            | 智能阅读助手               |
| privacyPolicyUrl| https://example.com/privacy  | https://example.com/privacy|

### App Store Version — iOS / macOS / visionOS
| Field         | Primary Locale (en-US) value | Planned value for [locale] |
|---------------|------------------------------|---------------------------|
| description   | (full text...)               | (translated text...)       |
| keywords      | rss,reader,feed              | RSS,阅读器,订阅            |
| whatsNew      | Bug fixes and improvements   | 问题修复与性能优化          |
| supportUrl    | https://example.com/support  | https://example.com/support|
| marketingUrl  | https://example.com          | https://example.com        |
```

**Wait for explicit user approval before proceeding to Phase 3.**

---

### Phase 3 — Execute

**Process each target language sequentially** (complete one language fully before starting the next):

1. **App Info Localization** (once per language) — `create_app_info_localization` or `update_app_info_localizations`
   - Always pass an explicit `name` value to avoid `DUPLICATE_NAME` conflicts.
   - App Info is platform-agnostic; only one record needs to be created/updated per locale.

2. **App Store Version Localization** (once per platform per language) — `create_app_store_version_localization` or `update_app_store_version_localizations`
   - Repeat for **each selected platform** (e.g., iOS → macOS → visionOS).
   - Set `whatsNew` to `nil` for v1.0 first releases.
   - Fill all fields that are present in the primary locale (Golden Rule).
   - Always set `supportUrl` via a separate `update_app_store_version_localizations` call after `create`, because `create` does not currently support URL fields.

**Error handling during execution:**
- **Network / transient errors** → auto-retry up to 2 times before reporting failure.
- **Business errors** (e.g., `DUPLICATE_NAME`, `STATE_ERROR`) → stop that field/locale, explain the issue to the user, and ask how to proceed. Do not silently skip.

---

### Phase 4 — Verify & Report

After all languages are processed, **re-fetch** the updated localizations and output a single summary report:

```
## Localization Summary Report

| Locale  | Platform | Action | Status    | Notes                                                  |
|---------|----------|--------|-----------|--------------------------------------------------------|
| zh-Hans | (shared) | CREATE | ✅ Done   | App Info                                               |
| zh-Hans | iOS      | CREATE | ✅ Done   |                                                        |
| zh-Hans | macOS    | CREATE | ✅ Done   |                                                        |
| ja      | (shared) | CREATE | ✅ Done   | App Info                                               |
| ja      | iOS      | UPDATE | ✅ Done   |                                                        |
| ja      | macOS    | UPDATE | ⚠️ Partial | DUPLICATE_NAME on `name` field — user action required |
```

Flag any field that is still empty in a target locale (parity violation) and prompt the user to resolve it.

t is still empty in a target locale (parity violation) and prompt the user to resolve it.

