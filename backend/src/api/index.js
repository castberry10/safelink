import express from 'express';
import check from './check/index.js';
import user from './user/index.js';
import system from './system/index.js';

const api = express.Router();

api.use('/check', check);
api.use('/users', user);
api.use('/system', system);

api.get('/', (_req, res) => {
  res.send('root api');
});

export default api;