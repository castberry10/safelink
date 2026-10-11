import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import morgan from 'morgan';
import api from './api/index.js';
import db from './db.js';

const { PORT, NODE_ENV } = process.env;
const app = express();

app.use(helmet());
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use('/api', api);
app.use(morgan('dev'));

const port = PORT || 11112;

async function start() {
  await db.$connect();
  console.log('Database connected');

  app.listen(port, () => {
    console.log('Listening to port %d', port);
  });

}

start().catch((err) => {
  console.error('Failed to start server:', err.message);
  process.exit(1);
});