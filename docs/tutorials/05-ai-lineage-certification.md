# 05. AI, Lineage, And Certification

Goal: show how DQL keeps AI useful by grounding it in certified blocks and
lineage instead of treating generated SQL as trusted by default.

## 1. Build The Knowledge Graph

```bash
npm run dql:agent:reindex
```

This indexes:

- DQL blocks
- App and dashboard metadata
- semantic-layer metrics and dimensions
- Skills under `.dql/skills/`
- lineage metadata

## 2. Open The Chat Notebook

Open `notebooks/chat_with_data.dqlnb`.

The notebook explains provider setup and shows how a chat cell can ask for a
new block proposal. Provider credentials are optional until you actually run an
AI request.

## 3. Ask A Certified-First Question

Good prompts:

```text
How did monthly revenue trend?
Which customer cohort has the strongest returning rate?
Which product type has the best gross margin?
```

Expected behavior:

1. Search certified blocks first.
2. Cite the matching block.
3. Execute through the governed block path when possible.
4. Mark generated SQL or new block proposals as review, not certified.

## 4. Trace Lineage Before Trusting An Answer

```bash
npm exec -- dql lineage --block "Revenue Mix by Month"
npm exec -- dql lineage --block "Customer Cohort Returning Rate"
npm exec -- dql lineage --block "Product Type Margin"
```

Lineage should tell you which dbt model and source path the answer depends on.

## 5. Run Certification Checks

For a specific block:

```bash
npm exec -- dql certify blocks/finance/revenue_mix_by_month.dql
```

For the full repo smoke:

```bash
npm run release:smoke
```

Certification should confirm required metadata, parseability, lineage, and test
assertions. Generated or AI-fixed blocks should stay in review until a human
approves them.

## 6. Promotion Flow

Use this flow for new work:

```text
Notebook SQL or AI proposal
  -> Save as draft block
  -> Add owner, domain, description, tests
  -> Validate
  -> Run certification
  -> Mark certified
  -> Use in App dashboard
```

That is the core DQL value in this repo: reusable, reviewable answer assets
instead of one-off SQL pasted into dashboards.
