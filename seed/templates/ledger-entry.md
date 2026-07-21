# Ledger: <NODE-PATH>

sized-as: <POINTS>
predicted: notional $<LOW>–$<HIGH> · cash $<CASH-LOW>–$<CASH-HIGH>
actual: <TOKENS> tokens · <HOURS> h · <AGENTS> agents
window_cost: ≈$<NOTIONAL-COST>          # NOTIONAL — plan-covered (opus/sonnet/haiku through Claude Code).
                                        # "What I would have paid." Spends the 5h/weekly allowance, never the bank.
cash_cost: $<CASH-COST>                 # REAL money out — fable API tokens + any pay-as-you-go overflow.
                                        # 0 is the normal, expected value. Non-zero requires a fable_optin ref.
models: <MODELS-PER-DISPATCH>           # e.g. conductor:opus · fleet:sonnet x3 · sweep:haiku · evaluator:sonnet
fable_optin: <NONE-OR-RULING-REF>       # v9: fable is owner opt-in, per invocation. NONE if fable was not used;
                                        # otherwise the DECISIONS pointer for the ruling that authorised it.
window_reading: <VALUE-OR-UNKNOWN> observed <TIMESTAMP> (<SOURCE>)
                                        # the allowance reading this dispatch was priced against, and its age.
                                        # UNKNOWN is a legal, distinct value — never write 0 for "not observed".
delta-why: <ONE-PARAGRAPH-HONEST-CAUSE>
sources: <TRANSCRIPT-OR-TOKEN-REPORT-REFS>
closed: <DATE>
