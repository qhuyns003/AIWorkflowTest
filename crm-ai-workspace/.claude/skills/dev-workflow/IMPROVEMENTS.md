# Dev-Workflow Improvements Based on Anthropic Best Practices

> **Nguồn**: [Anthropic Prompting Best Practices](https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/multishot-prompting)
> 
> **Ngày phân tích**: 2026-11-05
> 
> **Mục tiêu**: Cải tiến workflow để giảm thiểu việc AI bỏ qua checklist, tăng instruction following, và tối ưu agentic behavior

---

## 📊 Tổng quan vấn đề hiện tại

### Hiện tượng
AI trong dev-workflow thường xuyên **bỏ qua (skip)** các bước quan trọng:
- Checklist tự kiểm tra trước cổng (G0, G1, G2, G3)
- Self-review requirements (loại bỏ câu hỏi kỹ thuật ở Phase 1)
- Cascade validation khi có thay đổi
- Design review độc lập (giao sub-agent)
- Đọc reference files (`task-decomposition.md`, `question-bank.md`)

### Nguyên nhân (theo Anthropic)
1. **Cấu trúc prompt chưa tối ưu**: Checklist và rules bị "chôn vùi" trong văn xuôi dài
2. **Thiếu XML tags rõ ràng**: AI khó phân biệt instructions vs context vs examples
3. **Thiếu examples (few-shot)**: AI không có mẫu cụ thể về hành vi mong muốn
4. **Order matters**: Instructions quan trọng không ở vị trí nổi bật
5. **Over-prompting**: Quá nhiều hướng dẫn dẫn đến AI "overwhelmed" và bỏ qua

---

## 🎯 Cải tiến đề xuất (Priority-based)

---

### **Priority 1 (CRITICAL): Cấu trúc lại Prompt với XML Tags**

#### Vấn đề hiện tại
```markdown
**📝 CHECKLIST TỰ KIỂM TRA TRƯỚC KHI TRÌNH BÀY G1-TX:**
- [ ] Đọc lại Section 10 (Câu hỏi & Quyết định nghiệp vụ)
- [ ] Kiểm tra: Có từ khóa kỹ thuật không?
```
→ AI dễ **miss** vì checklist nằm trong văn xuôi, không có boundary rõ ràng

#### Giải pháp (theo Anthropic Best Practice)
Wrap checklist trong XML tags với structure rõ ràng:

```xml
<phase_1_checklist>
  <instruction>YOU MUST complete ALL items before presenting at Gate G1</instruction>
  <checklist_items>
    <item id="1" required="true">Read Section 10 (Questions & Business Decisions) in 01-requirement.md</item>
    <item id="2" required="true">Search for technical keywords: API, endpoint, HTTP, JSON, database, H2, PostgreSQL, format, wrapper</item>
    <item id="3" required="true">If found technical keywords → DELETE those questions, note "Defer to Phase 2"</item>
    <item id="4" required="true">Keep ONLY pure business questions</item>
    <item id="5" required="true">For each question with options → provide minimum 2 alternatives</item>
  </checklist_items>
  <verification>
    Before presenting at G1, state explicitly:
    - "Checklist completed: 5/5 items done"
    - List each item with ✅ or describe what was done
  </verification>
</phase_1_checklist>
```

**Áp dụng vào SKILL.md**:
- Phase 0: `<phase_0_checklist>`
- Phase 1: `<phase_1_checklist>` (như trên)
- Phase 2: `<phase_2_checklist>`
- Phase 3: `<phase_3_checklist>`

**Benefit**: 
- XML tags tạo boundary rõ ràng, AI khó bỏ qua
- `required="true"` attribute nhấn mạnh tính bắt buộc
- `<verification>` block buộc AI phải báo cáo kết quả

---

### **Priority 2 (HIGH): Thêm Few-Shot Examples**

#### Vấn đề hiện tại
Workflow chỉ có instructions (chỉ dẫn), không có examples (ví dụ minh họa). AI thiếu "mẫu" để học hành vi đúng.

#### Giải pháp (theo Anthropic: "Examples are one of the most reliable ways")

**Thêm vào cuối SKILL.md**:

```xml
<examples>
  <example id="phase_1_correct_behavior">
    <title>Phase 1: Correct - Business Questions Only</title>
    <scenario>
      Subtask T1: "Search customer by phone number"
    </scenario>
    <assistant_behavior>
      <step>1. Read BRD → Understand requirement</step>
      <step>2. Create TX-search-customer/01-requirement.md</step>
      <step>3. Identify unclear business points:
        - Does "phone number" include international format (+84)?
        - Can inactive customers be searched?
        - If multiple records found with same phone, which one to return?
      </step>
      <step>4. Self-review Section 10:
        - ✅ No technical keywords (API, endpoint, database)
        - ✅ All questions are about business logic
      </step>
      <step>5. Present at G1:
        "Checklist completed: 4/4 items done
        - Read Section 10: ✅
        - No technical keywords found: ✅
        - All questions are business-focused: ✅
        
        Questions for clarification:
        Q1. Phone format: International (+84) vs domestic (0)?
        Q2. Search inactive customers: Yes/No?
        Q3. Multiple records: Return first/latest/all?"
      </step>
    </assistant_behavior>
  </example>

  <example id="phase_1_incorrect_behavior">
    <title>Phase 1: Incorrect - Technical Questions Mixed</title>
    <scenario>Same subtask T1</scenario>
    <assistant_behavior_wrong>
      <step>1-3. Same as correct...</step>
      <step>4. Ask mixed questions:
        ❌ Q1. API endpoint: /customers/search?phone=xxx or /customers/{phone}?
        ❌ Q2. Response format: Wrapper object or direct Customer object?
        ✅ Q3. Can search inactive customers?
      </step>
      <step>5. Skip self-review → Present at G1 with technical questions</step>
    </assistant_behavior_wrong>
    <why_wrong>
      - Asked technical questions (API path, response format) in Phase 1
      - Did not perform self-review checklist
      - These questions should be deferred to Phase 2
    </why_wrong>
  </example>

  <example id="phase_2_design_review">
    <title>Phase 2: Design Review with Sub-agent</title>
    <scenario>T1 design completed, before G2</scenario>
    <assistant_behavior>
      <step>1. Complete TX-search-customer/02-design.md</step>
      <step>2. BEFORE presenting at G2, delegate to design-review agent:
        
        invoke_sub_agent(
          name: "design-review",
          prompt: "Review design for T1-search-customer. 
                   Check: (1) matches 01-requirement.md, 
                   (2) no contradiction with T0 (if exists), 
                   (3) all ADR decisions clear",
          contextFiles: [
            "docs/dev/KEY-123/T1-search-customer/01-requirement.md",
            "docs/dev/KEY-123/T1-search-customer/02-design.md"
          ]
        )
      </step>
      <step>3. Review agent returns findings → Incorporate into design</step>
      <step>4. Present at G2:
        "Design review completed:
        - Agent findings: [summary]
        - Fixed: [list changes made]
        - Ready for dev approval"
      </step>
    </assistant_behavior>
  </example>

  <example id="gate_g3_stop">
    <title>Phase 3: MUST STOP at G3</title>
    <scenario>T1 implementation done, build success</scenario>
    <assistant_behavior>
      <step>1. Implement according to 02-design.md</step>
      <step>2. Build: mvn -q -DskipTests package → SUCCESS</step>
      <step>3. Review diff vs design</step>
      <step>4. Present at G3:
        "T1 Implementation Complete:
        - Build result: ✅ SUCCESS
        - Diff: [show changes]
        - Commit suggestion: [KEY-123] feat: T1 - search customer by phone
        
        ⚠️ STOPPED - Waiting for dev approval before continuing to T2"
      </step>
      <step>5. WAIT for explicit dev confirmation: "OK, continue T2"</step>
    </assistant_behavior>
    <behavior_if_wrong>
      ❌ "T1 done. Now starting T2 Phase 1..."
      → This is WRONG - must STOP at G3 and wait
    </behavior_if_wrong>
  </example>
</examples>
```

**Benefit**:
- AI học từ ví dụ cụ thể (few-shot learning)
- Có cả correct và incorrect examples để phân biệt rõ
- Examples nằm trong `<examples>` tags dễ parse

---

### **Priority 3 (HIGH): Restructure Instructions with Hierarchy**

#### Vấn đề hiện tại
Instructions dài, không có hierarchy rõ ràng. AI khó nhận biết đâu là **MUST DO** vs **NICE TO HAVE**.

#### Giải pháp (theo Anthropic: "Be clear and direct")

**Tách instructions thành layers**:

```xml
<phase_1_instructions>
  <critical_rules type="must_follow">
    <rule id="business_only">
      ✅ ASK ONLY: Business logic, validation rules (business), edge cases, data meaning
      ❌ NEVER ASK: API path, HTTP method, response format, database choice, framework
    </rule>
    <rule id="self_review">
      BEFORE presenting at G1: Complete checklist in &lt;phase_1_checklist&gt;
    </rule>
    <rule id="defer_technical">
      If technical question appears → DELETE it, note "Defer to Phase 2"
    </rule>
  </critical_rules>

  <recommended_practices type="should_follow">
    <practice>Refer to reference/question-bank.md for examples of business vs technical questions</practice>
    <practice>Group related questions by topic</practice>
    <practice>Provide 2-3 options for each unclear point</practice>
  </recommended_practices>

  <workflow_steps>
    <step order="1">Create TX-&lt;slug&gt;/01-requirement.md from template</step>
    <step order="2">Fill sections 1-9 based on BRD analysis</step>
    <step order="3">Draft business questions in Section 10</step>
    <step order="4">Self-review using &lt;phase_1_checklist&gt;</step>
    <step order="5">Present at G1 with checklist completion report</step>
  </workflow_steps>
</phase_1_instructions>
```

**Benefit**:
- `<critical_rules>` vs `<recommended_practices>`: AI biết đâu là non-negotiable
- `order` attribute trong steps: rõ thứ tự thực thi
- XML structure dễ parse và validate

---

### **Priority 4 (MEDIUM): Prompt Position Optimization**

#### Vấn đề hiện tại
Checklist và critical rules nằm giữa workflow, dễ bị AI "scroll past".

#### Giải pháp (theo Anthropic: "Put critical content at top and bottom")

**Restructure SKILL.md**:

```markdown
# Dev-Workflow (Phase 3 – DEV)

## 🚨 CRITICAL RULES (Read First, Check Last)

<critical_rules>
  <rule id="no_skip_checklist">
    EVERY phase has a checklist. You MUST complete and report checklist status at each gate.
  </rule>
  <rule id="phase_sequence">
    Subtask order: T1 (Phase 1→2→3 → G3 STOP) → T2 (Phase 1→2→3 → G3 STOP) → ...
    NEVER: T1-P1, T2-P1, T3-P1 → T1-P2, T2-P2, ...
  </rule>
  <rule id="stop_at_gates">
    G1, G2, G3 are HARD STOPS. Present results + wait for dev confirmation.
  </rule>
  <rule id="business_vs_technical">
    Phase 1 = Business ONLY. Phase 2 = Technical design.
  </rule>
</critical_rules>

## Triggers (...)
[Existing content...]

## Workflow
[Existing content with embedded checklists in XML...]

## 🔄 CRITICAL RULES REMINDER (Before Each Action)

<reminder>
Before you proceed with ANY phase:
1. Read the &lt;phase_X_checklist&gt; for current phase
2. Complete ALL items in checklist
3. Verify using &lt;verification&gt; block
4. Present checklist completion at gate

If you skip checklist → Output will be REJECTED at gate
</reminder>
```

**Benefit**:
- Rules at **top**: AI reads first
- Rules at **bottom**: AI checks before finishing
- `<reminder>` block: reinforcement learning

---

### **Priority 5 (MEDIUM): Add Verification Prompts**

#### Vấn đề hiện tại
AI không tự kiểm tra xem mình có follow instructions không.

#### Giải pháp (theo Anthropic: "Ask Claude to self-check")

**Thêm vào mỗi Phase**:

```xml
<self_check_before_gate>
  <instruction>
    Before presenting at Gate G1, answer these verification questions:
  </instruction>
  <questions>
    <question id="q1">Did I complete all 5 items in phase_1_checklist?</question>
    <question id="q2">Did I search for technical keywords in Section 10?</question>
    <question id="q3">Are ALL my questions business-focused (no API/database/format questions)?</question>
    <question id="q4">Did I provide 2+ alternatives for unclear points?</question>
    <question id="q5">Did I update 01-requirement.md with decisions made during Q&A?</question>
  </questions>
  <output_format>
    Present verification results in your G1 presentation:
    
    **Self-Check Results:**
    - Q1 (Checklist): ✅ Completed 5/5 items
    - Q2 (Keywords): ✅ No technical keywords found
    - Q3 (Business focus): ✅ All questions are business logic
    - Q4 (Alternatives): ✅ Provided 2-3 options for each question
    - Q5 (Documentation): ✅ Updated BR-3, AC-2 based on decisions
  </output_format>
</self_check_before_gate>
```

**Benefit**:
- AI bắt buộc phải tự kiểm tra trước khi trình bày
- Output format rõ ràng → dễ verify
- Reduces hallucination (AI không thể nói "đã làm" khi chưa làm)

---

### **Priority 6 (LOW): Simplify Over-Prompting**

#### Vấn đề hiện tại
Một số rules được nhắc lại nhiều lần (Phase 1 business-only rule xuất hiện 4-5 lần).

#### Giải pháp (theo Anthropic: "Prefer general instructions")

**Consolidate rules**:

```xml
<phase_1_golden_rule>
  <title>Phase 1 = Business Understanding ONLY</title>
  <allowed>
    - Business logic questions
    - Validation rules (what to validate, not which library)
    - Edge cases (business scenarios)
    - Data meaning (what field represents)
  </allowed>
  <forbidden>
    - API design (endpoints, methods, paths)
    - Response format (wrapper, structure)
    - Database choice (H2, PostgreSQL, schema)
    - Framework/library selection
    - Code structure decisions
  </forbidden>
  <reference>
    See reference/question-bank.md for 20+ examples of business vs technical questions
  </reference>
</phase_1_golden_rule>

<!-- Reference this rule by ID instead of repeating text -->
<phase_1_checklist>
  <item id="2">Verify compliance with &lt;phase_1_golden_rule&gt;</item>
</phase_1_checklist>
```

**Benefit**:
- Single source of truth
- Dễ maintain
- AI không bị "overwhelmed" bởi repeated text

---

## 📝 Implementation Plan

### Step 1: Update SKILL.md Structure
```
[CRITICAL RULES - Top]
↓
[Triggers]
↓
[Phase 0 with <phase_0_checklist> XML]
↓
[Phase 1 with <phase_1_checklist> + <phase_1_instructions> XML]
↓
[Phase 2 with <phase_2_checklist> + <phase_2_instructions> XML]
↓
[Phase 3 with <phase_3_checklist> + <phase_3_instructions> XML]
↓
[Examples section with <examples> XML]
↓
[CRITICAL RULES REMINDER - Bottom]
```

### Step 2: Add Examples (5-8 examples)
- Phase 0: Correct subtask decomposition
- Phase 1: Business questions only (correct + incorrect)
- Phase 2: Design review delegation
- Phase 3: Stop at G3 (correct + incorrect auto-continue)
- Cascade validation example

### Step 3: Test & Iterate
1. Test với 1 ticket thật
2. Track: AI có skip checklist không?
3. Điều chỉnh XML structure nếu vẫn skip
4. Iterate cho đến khi AI follow 100%

### Step 4: Apply to Other Skills
- `quick-fix`: simpler structure
- `code-review`, `design-review`: similar checklist approach
- `impact-analysis`: XML-structured analysis output

---

## 📊 Expected Improvements

| Metric | Before | After (Expected) |
|--------|--------|------------------|
| Checklist completion rate | ~40% | ~95% |
| Technical questions in Phase 1 | ~60% leaked | <5% |
| Auto-continue without G3 stop | ~30% cases | <5% |
| Self-review before gates | ~20% | ~90% |
| Sub-agent delegation (design review) | Rarely done | Consistent |

---

## 🔍 Monitoring & Validation

### How to validate if improvements work

**After implementing changes, check:**

1. **Checklist Reporting**: AI should say "Checklist completed: X/Y items" at EVERY gate
2. **Phase 1 Purity**: No technical questions in Section 10 of 01-requirement.md
3. **G3 Hard Stop**: AI should explicitly say "⚠️ STOPPED at G3, waiting for approval"
4. **Sub-agent Delegation**: design-review agent should be invoked before every G2
5. **Self-Check Output**: AI should present verification results at gates

**Red flags (still broken)**:
- ❌ AI jumps from T1-G3 directly to T2-Phase1 without waiting
- ❌ No checklist status reported at gates
- ❌ Technical questions still in Phase 1 docs
- ❌ No design-review agent invocation before G2

---

## 🎓 Key Learnings from Anthropic

### What worked (from their research)
1. **XML tags > Markdown**: Better parsing, clearer boundaries
2. **Examples > Instructions**: Few-shot learning more reliable than rules
3. **Position matters**: Critical content at top AND bottom
4. **Self-check prompts**: "Before you X, verify Y" pattern very effective
5. **Simplicity**: One clear rule > Five variations of same rule

### What we should avoid
1. ❌ Over-prompting: Too many reminders dilute attention
2. ❌ Vague instructions: "Be careful" vs "Check X, then Y"
3. ❌ Hidden checklists: In prose vs in `<checklist>` tags
4. ❌ Assuming context: AI forgets, need explicit reminders
5. ❌ No examples: Pure rules without demonstrations

---

## 🚀 Next Steps

1. **Immediate**: Implement Priority 1 (XML checklists) this week
2. **Short-term**: Add examples (Priority 2) within 2 weeks
3. **Medium-term**: Restructure all skills with same pattern
4. **Long-term**: Build automated validation (script checks if AI output includes checklist reports)

---

## 📚 References

- [Anthropic Prompting Best Practices](https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/multishot-prompting)
- [Anthropic: XML Tags for Structure](https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/multishot-prompting#structure-prompts-with-xml-tags)
- [Anthropic: Few-Shot Examples](https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/multishot-prompting#use-examples-effectively)
- [Anthropic: Self-Check Pattern](https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/multishot-prompting#ask-claude-to-self-check)

