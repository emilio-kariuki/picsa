import express from 'express';
import morgan from 'morgan';
import EventsRouter from './api/v1/routes/events.js';
const app = express();
app.use(morgan('dev'));
app.use(express.json());
app.all('/', (req, res) => {
    res.json({ message: 'Welcome to Picsa' });
});
app.use('/api/v1/events', EventsRouter);
app.all('*', (req, res) => {
    res.status(404).json({ message: 'Route not found' });
});
const port = process.env.PORT || 4000;
app.listen({ port }, () => {
    console.log(`🚀 Server ready at http://localhost:${port}`);
});
//# sourceMappingURL=index.js.map