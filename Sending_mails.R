##########################################################################
# Writing mail and sending them through R using knitr and mailR packages #
# 2016/03/04                                                             #
##########################################################################
setwd("E:/gitperso/warehouse")

## Change directory to keep html and LaTeX outputs in a separate directory
dir.create("outputs", showWarnings = FALSE)
out_folder = "outputs/Sending_mails"
dir.create(out_folder, showWarnings = FALSE)
setwd("outputs/Sending_mails/")

########################################################
# Step 1: Create body document in html we wish to send #
########################################################
library(knitr)
# Output in html
spin("../../helpers/Sending_mails/knitr-spin.R")
# Output in pdf through LaTeX
# spin("../../helpers/Sending_mails/knitr-spin.R", format = "Rnw")

#################################
# Step 2: Prepare and send mail #
#################################
library(mailR)
to = c("recipient@qq.com")
subject = paste("Report for you --", Sys.Date())
attach.files = c("knitr-spin.pdf")
body = "knitr-spin.html"
send.mail(from = "sender@qq.com",
          to = to,
          subject = subject,
          body = body,
          html = TRUE,
          smtp = list(host.name = "mail.qq.com", 
                      port = 25, 
                      user.name = "sender", 
                      passwd = "my_password", 
                      ssl = FALSE),
          attach.files = attach.files,
          authenticate = TRUE,
          send = TRUE)