convert.to.sec <- function(X) {
  X <- strsplit(X, ":")
  sapply(X, function(Y) sum(as.numeric(Y) * c(3600, 60, 1)))
}

generate_brazil_holidays_prophet <- function(YearStart, YearEnd) {
  tibble(ds = date(as.character()), weekday = integer(), holiday = as.character(), lower_window = integer(), upper_window = integer()) %>%
  add_row(ds = ymd(timeDate::Easter(YearStart:YearEnd, -2)), holiday = "Easter Friday") %>%
  add_row(ds = ymd(timeDate::Easter(YearStart:YearEnd, -48)), holiday = "Carnival Monday", lower_window = 0, upper_window = 0) %>%
  add_row(ds = ymd(timeDate::Easter(YearStart:YearEnd, -47)), holiday = "Carnival Tuesday", lower_window = 0, upper_window = 0) %>%
  add_row(ds = ymd(timeDate::Easter(YearStart:YearEnd, -46)), holiday = "Carnival Wednesday", lower_window = 0, upper_window = 0) %>%
  add_row(ds = ymd(timeDate::Easter(YearStart:YearEnd, 60)), holiday = "CorpusChristi") %>%
  add_row(ds = seq(ymd(paste0(YearStart, "-01-01")), ymd(paste0(YearEnd, "-01-01")), by = "years"), holiday = "New Year's Day") %>%
  add_row(ds = seq(ymd(paste0(YearStart, "-01-25")), ymd(paste0(YearEnd, "-01-25")), by = "years"), holiday = "Sao Paulo Anniversary") %>%
  add_row(ds = seq(ymd(paste0(YearStart, "-04-21")), ymd(paste0(YearEnd, "-04-21")), by = "years"), holiday = "Tiradentes") %>%
  add_row(ds = seq(ymd(paste0(YearStart, "-05-01")), ymd(paste0(YearEnd, "-05-01")), by = "years"), holiday = "Workers' Day") %>%
  add_row(ds = seq(ymd(paste0(YearStart, "-09-07")), ymd(paste0(YearEnd, "-09-07")), by = "years"), holiday = "Independece Day") %>%
  add_row(ds = seq(ymd(paste0(YearStart, "-10-12")), ymd(paste0(YearEnd, "-10-12")), by = "years"), holiday = "Our Lady of Apparition") %>%
  add_row(ds = seq(ymd(paste0(YearStart, "-11-02")), ymd(paste0(YearEnd, "-11-02")), by = "years"), holiday = "All Souls' Day") %>%
  add_row(ds = seq(ymd(paste0(YearStart, "-11-15")), ymd(paste0(YearEnd, "-11-15")), by = "years"), holiday = "Republic Day") %>%
  add_row(ds = seq(ymd(paste0(YearStart, "-11-20")), ymd(paste0(YearEnd, "-11-20")), by = "years"), holiday = "Black Awareness Day") %>%
  add_row(ds = seq(ymd(paste0(YearStart, "-12-24")), ymd(paste0(YearEnd, "-12-24")), by = "years"), holiday = "Christmas Eve") %>%
  add_row(ds = seq(ymd(paste0(YearStart, "-12-25")), ymd(paste0(YearEnd, "-12-25")), by = "years"), holiday = "Christmas Day") %>%
  add_row(ds = seq(ymd(paste0(YearStart, "-12-31")), ymd(paste0(YearEnd, "-12-31")), by = "years"), holiday = "New Year's Eve") %>%
  mutate(
    weekday = wday(ds),
    lower_window = ifelse(is.na(lower_window), ifelse(weekday == 3, -1, 0), lower_window),
    upper_window = ifelse(is.na(upper_window), ifelse(weekday == 5, 1, 0), upper_window)) %>%
  tsibble::as_tsibble(index=ds) %>%
  assign("holidays_brazil_prophet",.,envir = .GlobalEnv)
}
  
generate_brazil_holidays <- function(YearStart, YearEnd){
  generate_brazil_holidays_prophet(YearStart, YearEnd) %>%
    dplyr::filter(lower_window != 0 | upper_window != 0) %>%
    mutate(
      ds = (ds + days(upper_window) + days(lower_window)),
      holiday = paste(holiday, " Bridge"),
      lower_window = 0,
      upper_window = 0
    ) %>%
    bind_rows(holidays_brazil_prophet, .) %>%
    select(ds, holiday) %>%
    rename(date = ds) %>%
    distinct(date, .keep_all = TRUE) %>%
    arrange(date) %>%
    mutate(date = as.Date(as.POSIXct(date))) %>% 
    assign("holiday_brazil",.,envir = .GlobalEnv)
}

