test_that('structure and names are correct', {
  res <- rsi(effect = 0.5, se = 0.2, N = 100, plot = FALSE)
  expect_type(res, 'list')
  expect_named(res,
               c('RSI', 'Skewness', 'RSI_star', 'Mean_p', 'SD_p'),
               ignore.order = TRUE)
})
