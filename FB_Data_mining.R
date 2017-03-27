install.packages("Rfacebook")
install.packages("httpuv")
install.packages("RcolorBrewer")
install.packages("Rcurl")
install.packages("rjason")
install.packages("httr")

#text mining package
install.packages("rJava")
install.packages("wordcloud")
install.packages("tm")
install.packages("tmcn", type="source", repos="http://R-forge.R-project.org")
install.packages("Rwordseg", repos="http://R-Forge.R-project.org")


library(wordcloud)
library(Rfacebook)
library(httpuv)
library(RColorBrewer)

myaccess_taken="EAACEdEose0cBAD7NCCxH5ZAUkPf4OH1cK3q2dRWRsvUfwYwlEUs6sbtlij50ZBIeDfutLQ0qrZCQFgUUJPFgBeHt7GECV7LWOxjks0ZCLjDzZBFoIHIAFZAXwwmhx6yvZCeK5h9fgYYRApb1Osu291YbbAxI1RSywwmiaTbMzGwJQZDZD"
options(Rcurloptions=list(verbose=FALSE,capath=system.file("curlssl","cacert.pem",package = "Rcurl")))

me<-getUsers("me",token = myaccess_taken)
#simplify T 簡化資料 , F詳細資料 
my_friends<-getFriends(token = myaccess_taken,simplify = FALSE)

#page , n=to get num of posts, default=all
FB_page<-getPage(page="tsaiingwen",since = '2016/08/01',n=100,token = myaccess_taken)
datapost<-data.frame(FB_page)

rm(datapost)

#max like_count post
FB_page[which.max(FB_page$likes_count),]


#wordcould
wordcloud(FB_page$message,FB_page$likes_count)
#wordcloud(FB_page$message , FB_page$comments_count)

#missing value ; find which value is missed
is.na(FB_page$message)



#creat csv
write.table(FB_page, file = "myFB_posts_results.CSV", row.names =FALSE,sep = ",",na = "NA")
write.csv(FB_page,file = "myFB_posts_results2.CSV",row.names = FALSE)
rm(data)
data<-read.csv(file.choose(),header = TRUE)
getwd()

#===============================================
#text mining
library(tm)
library(tmcn)
library(Rwordseg)
#doc 是儲存文件的資料夾,這些文章變成我們分析的語料庫。
rm(datapost)
