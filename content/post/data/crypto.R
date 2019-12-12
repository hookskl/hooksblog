library(jsonlite)
library(tidyverse)

api = 'https://api.coinmarketcap.com/v1/ticker/?limit=0'

crypto_market <- fromJSON(api)
str(crypto_market)

#munge data types

for(i in 4:length(crypto_market)) {
  crypto_market[,i] <- as.numeric(crypto_market[,i])
}

str(crypto_market)

#convert to tibble
crypto_market <- as_tibble(crypto_market)
crypto_market

#only market cap
market_cap_raw <- crypto_market %>%
  select(id, market_cap_usd) %>%
  filter(market_cap_usd > 0)

#create market cap %
market_cap_raw <- market_cap_raw %>%
  mutate(market_cap_perc = market_cap_usd / sum(market_cap_usd))

theme_set(theme_bw())
market_cap_raw[1:10,] %>%
  ggplot(aes(x = id, y = market_cap_perc, fill = id)) + 
  geom_bar(stat = 'identity') + 
  geom_text(aes(label=paste(as.character(round(market_cap_perc, 2) * 100), "%"), vjust=-0.3, size=3.5))
            
            