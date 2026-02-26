import express from 'express';
import cors from 'cors';
import usersRoutes from './routes/uers.routes';

export const app = express();

app.use(cors());
app.use(express.json());
app.use('/users', usersRoutes);

if (process.env.NODE_ENV !== 'test') {
    app.listen(3000, () => {
      console.log('Server running on http://localhost:3000');
    });
  }