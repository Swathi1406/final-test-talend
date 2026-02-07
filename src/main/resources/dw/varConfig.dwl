%dw 2.0
import fn from modules::fileNames
output application/java
---
fn::buildFileNames(vars.varFlowName)