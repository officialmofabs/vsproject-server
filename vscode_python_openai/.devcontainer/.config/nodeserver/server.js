require('dotenv').config();
const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const compression = require('compression');
const rateLimit = require('express-rate-limit');
const morgan = require('morgan');

const app = express();
const PORT = process.env.PORT || 3000;

// Security Middleware
app.use(helmet());

// Enable CORS (Modify origins as needed)
app.use(cors({ origin: '*' }));

// Enable request compression
app.use(compression());

// Rate Limiting to prevent abuse
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // Limit each IP to 100 requests per window
  message: 'Too many requests, please try again later.',
});
app.use(limiter);

// Logging
app.use(morgan('combined'));

// Parse JSON & URL-encoded data
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Sample Route
app.get('/', (req, res) => {
  res.json({ message: 'Node.js Server Running Successfully!' });
});

// Start Server
app.listen(PORT, () => {
  console.log(`✅ Server running on port ${PORT}`);
});

module.exports = app;
