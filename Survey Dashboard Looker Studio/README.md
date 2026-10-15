# Survey Impact Measurement Dashboard

> Volunteer data project · Looker Studio · Google Sheets · Education Analytics

An interactive dashboard tracking the educational impact of a youth tutoring nonprofit across multiple survey cohorts, participant groups, school sites, and years.  
  
[![View Live Dashboard](https://img.shields.io/badge/Looker%20Studio-View%20Live%20Dashboard-4285F4?style=for-the-badge&logo=googleanalytics&logoColor=white)](https://datastudio.google.com/s/l-1A0yx2OA4)


---

## Screenshots

**Cockpit — overview across all surveys**

![Dashboard cockpit: KPI tiles for participants, schools and cities with trend sparklines, a ranked poll table, and satisfaction gauges by group](<images/ dashboard-cockpit.png>)

**Younger Students page — question-level drill-down**
![Younger Students page: Yes/No and Scale question tables with participation and consent rates, cross-filtering to a stacked bar chart showing answer distributions](<images/dashboard-students.png>)

---

## Overview

The organization conducts recurring surveys across multiple participant groups — younger students, older students, parents, school staff, and tutors — and needed a way to track outcomes reliably across years and sites without manual data assembly each cycle.

The result is a **Looker Studio dashboard** built on a long-format master data table in Google Sheets, with cross-filtering by year, group, survey type, city, school, and partner.

| | |
|---|---|
| **Participant responses** | 13,500+ across all survey cycles |
| **Surveys** | 26 merged into one master table |
| **Stable question codes** | 852 (survives question rewording across years) |
| **Participant groups** | 6 (younger students, older students, parents, school staff, tutors, reading program) |

---

## Dashboard Features

- **Cockpit page** — KPI tiles (participants, schools, cities) with year-over-year trend sparklines; ranked poll table; satisfaction gauges by group
- **Group-specific pages** — separate pages for younger students, older students, parents, and school staff
- **Cross-filtering** — click any question in the table to see its full answer distribution as a stacked bar chart; hold Ctrl to select multiple questions
- **Question type separation** — Yes/No questions and Scale questions displayed in distinct table blocks with appropriate chart types (donut for Yes/No, stacked bar for Scale)
- **Filters** — Year, Group, Poll type, City, School, Partner; all filters apply across the whole page simultaneously
- **Participation & consent rates** — each question row shows both response count and consent rate

---

## Data Architecture

Survey exports arrive in wide format (one row per participant, each question as a column). The master data table reshapes this into long format: one row per `(question × answer option × survey)`, with aggregated counts.

The central design decision is the **Stable Code system**: every question receives a permanent code (e.g. `WUS_001`) that survives minor rewording across survey years. A lookup table of 852 entries maps each question's text — via a normalized key — to its stable code. When wording changes, an alias is added; the code stays the same, so historical chart data in Looker Studio is preserved without rebuilding computed fields.

```
XLOOKUP_Key = LOWER( Gruppe | MainQuestion [ // SubQuestion ] )
            → Stable_Code  (e.g. WUS_001, WOS_040, WEL_003)
```

---

## Tech Stack

| Layer | Tool | Purpose |
|---|---|---|
| Survey platform | LamaPoll | Source of all survey exports |
| Storage | Google Sheets | Master data table, Codes lookup, survey metadata |
| Visualization | Looker Studio | Interactive dashboard; computed fields via Stable_Code |
| Translation | Python + JSON | DE→EN translation pipeline for English data export |

---

## Repository Contents

```
survey-impact-dashboard/
├── images/
│   ├── dashboard-cockpit.png      # Cockpit overview screenshot
│   └── dashboard-students.png    # Younger Students page screenshot
├── translation/
│   └── translation_dict.json     # DE→EN translations: questions and answer options
├── data/
│   └── Chancenwerk_EN.xlsx       # Anonymized English version of master data (synthetic)
└── README.md
```

> **Note on data privacy:** All data shared in this repository is synthetic or anonymized. Real survey responses are not included. The master data table contains aggregated counts (not individual responses).

---

## About

Built as a volunteer contribution to a data-for-good project pairing data professionals with civil society organizations in Germany. The project ran 2025–2026.

**My contributions:** Looker Studio dashboard design and architecture · Stable Code system and Codes lookup table (852 entries) · DE→EN translation pipeline for the English data export
