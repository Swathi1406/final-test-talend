
%dw 2.0
import * from dw::core::Strings
output application/csv header=true
---
payload
  filter (
    ($.Quantidade_Calculada_Horas == null or $.Quantidade_Calculada_Horas == 0.0)
    and !(isEmpty($.Absence_Date) and isEmpty($.First_Day_of_Leave) and isEmpty($.Last_Day_of_Leave))
  )
  map {
    MOT_APP_ID:  getMOT_APP_ID($),
    EMPLOYEE_ID: $.Employee_ID,
    START_DATE:  if (!isEmpty($.First_Day_of_Leave))
                    parseLeaveDate($.First_Day_of_Leave) as String {format: "yyyy-MM-dd"}
                 else 
                    parseAbsenceDate($.Absence_Date) as String {format: "yyyy-MM-dd"},
    END_DATE:    if (!isEmpty($.Last_Day_of_Leave))
                    parseLeaveDate($.Last_Day_of_Leave) as String {format: "yyyy-MM-dd"}
                 else 
                    parseAbsenceDate($.Absence_Date) as String {format: "yyyy-MM-dd"},
    STATUS:      getStatus($.Accao)
  }

fun getMOT_APP_ID(r) =
  if (!isEmpty(r.MOT_AP_ID_Licenca)) 
    trim(r.MOT_AP_ID_Licenca)[0 to 4]
  else if (!isEmpty(r.MOT_AP_ID_Ferias))
    if ((trim(r.MOT_AP_ID_Ferias)[0 to 1]) == "F") "2072" else r.MOT_AP_ID_Ferias
  else if (!isEmpty(r.MOT_AP_ID_Time_off)) 
    trim(r.MOT_AP_ID_Time_off)[0 to 4]
  else ""

fun parseAbsenceDate(d) = (d as Date {format: "yyyy/MM/dd"})
fun parseLeaveDate(d)   = (d as Date {format: "yyyy-MM-dd"})
fun getStatus(a) =
  if (isEmpty(a)) ""
  else if (lower(trim(a)) == "corrigido") "X"
  else ""
