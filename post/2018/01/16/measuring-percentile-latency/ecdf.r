#!/usr/bin/env Rscript
# Generates graphs for a blog post
# by Andrew Brampton (bramp.net)

#install.packages("ggplot2")
#install.packages('svglite')
library(ggplot2)

data = read.csv("data.csv", header = FALSE, col.names = c("x"))

percenty = 0.99
percentx = quantile(data$x, percenty, names=FALSE)

# The 1st graph
h1 <- data.frame(bins = sort(data$x), ecdf = ecdf(data$x)(sort(data$x)))
h1$name <- "exact"

h <- h1
ggplot(h, aes(x = bins, y = ecdf, colour=name)) +
#  stat_ecdf(data=data, aes(x = x), geom = "step") +
  geom_line(show.legend=F) +
  labs(x = "Latency (seconds)", y = "ecdf(x)") + 
  coord_cartesian(xlim=c(0, 20), ylim=c(0.5, 1)) + # Zoom into the graph
  scale_y_continuous(labels = scales::percent) +
  geom_vline(xintercept = percentx, color = "gray", linetype=2) +
  geom_hline(yintercept = percenty, color = "gray", linetype=2) +
  annotate("text", x = 5, y = percenty, label = scales::percent(percenty),
    vjust = -0.2, size=calc_element('axis.text', theme_get())$size/ggplot2:::.pt) +
  annotate("text", x = percentx, y = 0.75, label = sprintf("%f s", percentx) ,
    hjust = -0.1, size=calc_element('axis.text', theme_get())$size/ggplot2:::.pt)

ggsave("1st.png", scale = 1, width = 6.4, height = 3.2, units = "in", dpi = 300)
ggsave("1st.svg", scale = 1, width = 6.4, height = 3.2, units = "in", dpi = 300)

# The 2nd graph with approximations
h2 <- hist(data$x, plot=FALSE, breaks=c(0, 2 ^ seq(0, 16)) / 1000)
h2 <- data.frame(bins = c(h2$breaks), ecdf=c(0, cumsum(h2$counts) / sum(h2$counts)))
h2$name <- "powers of 2 (approx)"

h3 <- hist(data$x, plot=FALSE, breaks=c(0, sqrt(2) ^ seq(0, 32)) / 1000)
h3 <- data.frame(bins = c(h3$breaks), ecdf=c(0, cumsum(h3$counts) / sum(h3$counts)))
h3$name <- "powers of √2 (approx)"

h <- rbind(h1, h2, h3)
ggplot(h, aes(x = bins, y = ecdf, colour=name)) +
  geom_line() +
  labs(x = "Latency (seconds)", y = "ecdf(x)") + 
  coord_cartesian(xlim=c(0, 20), ylim=c(0.8, 1)) + # Zoom into the graph
  scale_y_continuous(labels = scales::percent) +
  geom_hline(yintercept = percenty, color = "gray", linetype=2) +
  annotate("text", x = 5, y = percenty, label = scales::percent(percenty),
    vjust = -0.2, size=calc_element('axis.text', theme_get())$size/ggplot2:::.pt) +
  theme(legend.position = c(0.99, 0.03), legend.justification = c('right', 'bottom')) +
  guides(colour=guide_legend(title="Bin Ranges"))

ggsave("2nd.png", scale = 1, width = 6.4, height = 3.2, units = "in", dpi = 300)
ggsave("2nd.svg", scale = 1, width = 6.4, height = 3.2, units = "in", dpi = 300)

warnings()