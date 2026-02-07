%dw 2.0
import fn from modules::fileNames
output application/json
---
fn::buildFileNames(vars.varFlowName)