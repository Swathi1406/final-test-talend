%dw 2.0

fun buildFileNames(flowKey) =
  do {
    var cfg      = readUrl("classpath://flows.json", "application/json")
    var entry    = cfg.flows[flowKey] default {}
    var ext      = (cfg.extension default ".csv") as String
    var yyyyMMdd = (now() as String { format: "yyyyMMdd" })
    var stamp    = (now() as String { format: "yyyyMMddHHmmss" })
  ---
    if (isEmpty(entry)) 
      {
        error: "Unknown flow key",
        flowKey: flowKey
      }
    else
      {
        SFTPInputFileName: (entry.inputPrefix  default "") ++ yyyyMMdd ++ ext,
        OutputFileName:    (entry.outputPrefix default "") ++ yyyyMMdd ++ "_" ++ stamp ++ ext,
        EncryptionFlag:    (entry.encryptionFlag default false),
        dwlMappingFile:    (entry.dwlMappingFile default "")
      }
  }