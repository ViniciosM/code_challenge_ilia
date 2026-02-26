import express from 'express';
import cors from 'cors';
import usersRoutes from './routes/users.routes';

export const app = express();

app.use(cors());
app.use(express.json());

app.get('/ping', (_, res) => {
  res.json({ ok: true });
});

app.use('/users', usersRoutes);

if (process.env.NODE_ENV !== 'test') {
  const PORT = process.env.PORT || 3000;

  app.listen(PORT, () => {
    console.log(`🚀 Server running on http://localhost:${PORT}`);
  });
}