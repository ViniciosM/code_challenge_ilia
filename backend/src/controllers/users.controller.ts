import { Request, Response } from 'express';
import { z } from 'zod';
import { addUser, listUsers } from '../services/users.service';

export async function getUsers(req: Request, res: Response) {
  const users = await listUsers();
  res.json(users);
}

export async function createUser(req: Request, res: Response) {
  const schema = z.object({
    name: z.string().min(1),
    email: z.email(),
  });

  const parsed = schema.safeParse(req.body);

  if (!parsed.success) {
    return res.status(400).json({ error: 'Invalid data' });
  }

  try {
    const user = await addUser(parsed.data.name, parsed.data.email);
    return res.status(201).json(user);
  } catch (error: any) {
    if (error.code === 'P2002') {
      return res.status(409).json({ error: 'Email already exists' });
    }

    return res.status(500).json({ error: 'Internal server error' });
  }
}