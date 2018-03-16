library(tidyverse)
library(reshape2)
library(streamgraph)
library("htmlwidgets")

#import data
df = read_csv('blogs_by_title.csv')


df %>%
  mutate(title = gsub("11 Free Websites", "Eleven Free Websites", title, fixed = TRUE)) %>%
  mutate(title = gsub(" | The New York Public Library", "", title, fixed = TRUE)) %>%
  group_by(title, month=floor_date(date, "monthly"), rank) %>%
  summarize(total=sum(unique_pageviews)) %>%
  streamgraph(key=title, value=total, date=month, offset="zero", interpolate="basis", left = 100, bottom = 50) %>% 
  sg_fill_manual(c('#d3d3d3','#e41a1c','#377eb8','#4daf4a','#984ea3','#ff7f00','#e41a1c','#377eb8','#4daf4a','#984ea3','#ff7f00')) %>% 
  sg_axis_x(1, "year", "%Y") %>%
  sg_legend(show=TRUE, label="Blog posts: ") %>%
  saveWidget(file="NYPL_blogs_streamgraph.html", selfcontained = TRUE, title = "Top NYPL Blogs")

change_font <- function(file, font){
  css_ptn = 'svg%20text%20%7B%0Afont%3A%20\\d+?px'
  txt <- readLines(file)
  prac <- txt[grep(css_ptn, txt)]
  txt[grep(css_ptn, txt)] <- gsub(css_ptn, paste0('svg%20text%20%7B%0Afont%3A%20',font,'px'), txt[grep(css_ptn, txt)])
  writeLines(txt, file)
}

change_font(file.path('./', "NYPL_blogs_streamgraph.html"), 20)

