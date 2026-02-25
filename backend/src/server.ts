import express from 'express';
import cors from 'cors';
import usersRoutes from './routes/uers.routes';

const app = express();

app.use(cors());
app.use(express.json());

app.use('/users', usersRoutes);

app.listen(3000, () => {
  console.log('Server running on http://localhost:3000');
});