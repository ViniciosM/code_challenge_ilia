import request from 'supertest';
import { app } from '../server';
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

describe('Users API', () => {
  beforeEach(async () => {
    await prisma.user.deleteMany();
  });

  afterAll(async () => {
    await prisma.$disconnect();
  });

  it('should create user successfully', async () => {
    const response = await request(app)
      .post('/users')
      .send({
        name: 'Vinicios',
        email: 'vinicios@email.com',
      });

    expect(response.status).toBe(201);
    expect(response.body.name).toBe('Vinicios');
    expect(response.body.email).toBe('vinicios@email.com');
  });

  it('should not allow duplicate email', async () => {
    await request(app).post('/users').send({
      name: 'Vinicios',
      email: 'vinicios@email.com',
    });

    const response = await request(app)
      .post('/users')
      .send({
        name: 'Outro',
        email: 'vinicios@email.com',
      });

    expect(response.status).toBe(409);
  });

  it('should return users list', async () => {
    await request(app).post('/users').send({
      name: 'Vinicios',
      email: 'vinicios@email.com',
    });

    const response = await request(app).get('/users');

    expect(response.status).toBe(200);
    expect(response.body.length).toBe(1);
  });

  it('should validate invalid data', async () => {
    const response = await request(app)
      .post('/users')
      .send({
        name: '',
        email: 'invalid',
      });

    expect(response.status).toBe(400);
  });
});