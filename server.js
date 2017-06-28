const express = require('express')
const favicon = require('serve-favicon')
const path = require('path')
const app = express()

app.use(favicon(path.join(__dirname, 'public', 'favicon.ico')))
app.use(express.static('public'))

module.exports = app
