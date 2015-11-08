# ========== this part is the same for all scripts of this repo ============= #
file_URL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(file_URL, "household_power_consumption.zip")
unzip("household_power_consumption.zip", exdir = "household_power_consumption")

# my choice is to read the data from just required dates
txt <- "household_power_consumption.txt"
col_names = c("Date", "Time", "Global_active_power", "Global_reactive_power", 
              "Voltage", "Global_intensity", "Sub_metering_1", "Sub_metering_2",
              "Sub_metering_3")
dat <- read.table(text = grep("^[1,2]/2/2007", readLines(txt), value = TRUE),
                  header = TRUE,
                  col.names = col_names,
                  sep = ";",
                  na.strings = "?",
                  stringsAsFactors = FALSE)
library(dplyr)
data_set <- tbl_df(dat)
# convert the Date and Time variables to Date/Time classes
data_set$Date <- as.Date(data_set$Date, format = "%d/%m/%Y")
datetime <- paste(data_set$Date, data_set$Time)
data_set <- mutate(data_set, datetime = as.POSIXct(datetime))
# =========================================================================== #
old_par <- par()
png(width = 480, height = 480, file = "plot4.png")
par(mfcol = c(2, 2), cex = 0.8)
with(data_set, {
    plot(data_set$datetime, data_set$Global_active_power, type = "l", xlab = "", 
         ylab = "Global Active Power")
    plot(data_set$datetime, data_set$Sub_metering_1, type = "l", xlab = "", 
         ylab = "Energy sub metering")
    lines(data_set$datetime, data_set$Sub_metering_2, col = "red")
    lines(data_set$datetime, data_set$Sub_metering_3, col = "blue")
    legend("topright", col = c("black", "red", "blue"),  
           lty = 1, bty = "n", cex = 0.9, 
           legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
    plot(data_set$datetime, data_set$Voltage, type = "l", xlab = "datetime", 
         ylab = "Voltage")
    plot(data_set$datetime, data_set$Global_reactive_power, type = "l", 
         xlab = "datetime", ylab = "Global_reactive_power")
})
dev.off()
par(old_par)