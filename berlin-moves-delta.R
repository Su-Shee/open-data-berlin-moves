library(plyr)
library(ggplot2)
library(scales)
library(RColorBrewer)

file <- 'berlin-moves-data.csv'
csv  <- read.csv(file, header = TRUE, sep = ';')

years     = c(csv$year)
moves_in  = c(csv$to)
moves_out = c(csv$from)

dataset  <- data.frame(x = years, y = moves_in - moves_out)

mycolors <- ifelse(dataset$y < 0, '#ab003c', '#006b55')

plot <- ggplot(dataset, aes(x, y)) +
        geom_bar(stat = "identity", show_guide = FALSE, aes(fill = mycolors)) +
        geom_text(aes(label = sprintf("%.2f", y), size = 8, vjust = ifelse(y >= 0, -0.5, 1.5))) +
        scale_x_continuous(breaks = years, name = '') +
        scale_fill_manual(values = mycolors) + 
        ylab("numbers in thousands") +
        ggtitle("People moved in and out of Berlin")

theme <- theme_update( axis.text.x      = element_text(angle = 45, hjust = 1), 
                       axis.ticks       = element_blank(), 
                       panel.grid.major = element_line(colour = "grey90"),
                       panel.grid.minor = element_blank(), 
                       panel.background = element_blank(),
                       legend.position  = "none",
                       plot.title       = element_text(face = "bold", vjust = 1.5, size = 14)
                     )



