##
# Compute key of IBAN for French accounts
##
library(gmp)

fr76 = "152776"
bank = "14XXX"
desk = "000XX"
account = "7XXXXXXXXXX"

for(i in as.character(0:9)) {
  for(j in as.character(0:9)) {
    base = paste0(bank, desk, account)
    key = paste0(i, j)
    x = paste0(base, key, fr76)
    mod_out = mod.bigz(as.bigz(x), as.bigz(97))
    if(mod_out == as.bigz(1L)) {
      print(key)
    }
  }
}
