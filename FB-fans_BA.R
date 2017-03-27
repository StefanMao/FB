install.packages("devtools")
library(devtools)
install_github("Rfacebook", "pablobarbera", subdir="Rfacebook")
library(Rfacebook)


token <-"EAACEdEose0cBAN292cHxFPio07cFrvZBZAcKXLkxz3eryVo8Hunu6NGUXI33uLhZCnaF71hBv1RVXsafBN1lgC4H5ZC8VcNQ9CEKyEXkoBsckGVaFXgQknIIDzELR3ZCDchrCjLg6SpkfZAJcJMfEKrgHdPuJhEkz6vP4SnKfXLgZDZD"
me <- getUsers("me", token, private_info = TRUE)
me$name

page.id<-"YuntechMBA"
page <- getPage(page.id, token, n = 300)
str(page)


## convert Facebook date format to R date format
format.facebook.date <- function(datestring) {
  date <- as.POSIXct(datestring, format = "%Y-%m-%dT%H:%M:%S+0000", tz = "GMT")
}

# aggregate metric counts over month
aggregate.metric <- function(metric) {
  m <- aggregate(page[[paste0(metric, "_count")]], list(month = page$month),
                 mean)
  m$month <- as.Date(paste0(m$month, "-15"))
  m$metric <- metric
  return(m)
}

# create data frame with average metric counts per month
page$datetime <- format.facebook.date(page$created_time)
page$month <- format(page$datetime, "%Y-%m")
df.list <- lapply(c("likes", "comments", "shares"), aggregate.metric)
df <- do.call(rbind, df.list)

# visualize evolution in metric
library(ggplot2)
library(scales)
ggplot(df, aes(x = month, y = x, group = metric)) +
  geom_line(aes(color = metric)) +
  scale_y_log10("Average count per post",
                breaks = c(2,5,10,20)) +
  theme_bw() +
  theme(axis.title.x = element_blank())

# top post 
top.post <- page[which.max(page$likes_count), ]
top.post

#分析這一篇文章按讚的人：
post <- getPost(top.post$id, token, n = 1000, likes = TRUE, comments = FALSE)
users <- getUsers(post$likes$from_id, token)
head(sort(table(users$last_name), decreasing = TRUE))

#=================================================================
result<-NULL
for(i in 1:228){
  post <- getPost(page$id[i], token, n = 1000, likes = TRUE, comments = FALSE)
  users <- c(users,getUsers(post$likes$from_id, token))
}
head(sort(table(users$name),decreasing = TRUE))
