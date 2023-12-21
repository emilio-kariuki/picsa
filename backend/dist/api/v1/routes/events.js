import { Router } from 'express';
import { prisma } from '../../../db.js';
const router = Router();
router.get('/:id', async (req, res) => {
    try {
        const response = await prisma.events.findMany({
            where: {
                id: req.params.id
            }
        });
        res.json(response);
    }
    catch (err) {
        res.status(500).json({ message: "Error getting events" });
    }
});
router.get('/user/:id', async (req, res) => {
    try {
        const response = await prisma.events.findMany({
            where: {
                userId: req.params.id
            }
        });
        res.json(response);
    }
    catch (err) {
        res.status(500).json({ message: "Error getting events" });
    }
});
router.get('/', async (req, res) => {
    try {
        const response = await prisma.events.findMany();
        res.json(response);
    }
    catch (err) {
        res.status(500).json({ message: "Error getting events" });
    }
});
router.post('/', async (req, res) => {
    try {
        const response = await prisma.events.create({
            data: req.body
        });
        res.json(response);
    }
    catch (err) {
        res.status(500).json({ message: "Error creating event" });
    }
});
router.put('/:id', async (req, res) => {
    try {
        const response = await prisma.events.update({
            where: {
                id: req.params.id
            },
            data: req.body
        });
        res.json(response);
    }
    catch (err) {
        res.status(500).json({ message: "Error updating event" });
    }
});
router.delete('/:id', async (req, res) => {
    try {
        const response = await prisma.events.delete({
            where: {
                id: req.params.id
            }
        });
        res.json(response);
    }
    catch (err) {
        res.status(500).json({ message: "Error deleting event" });
    }
});
router.post('/join/:id', async (req, res) => {
    try {
        const response = await prisma.user.update({
            where: {
                id: req.body.userId
            },
            data: {
                Events: {
                    connect: {
                        id: req.params.id
                    }
                }
            }
        });
        res.json(response);
    }
    catch (err) {
        res.status(500).json({ message: "Error joining event" });
    }
});
router.post('/leave/:id', async (req, res) => {
    try {
        const response = await prisma.user.update({
            where: {
                id: req.body.userId
            },
            data: {
                Events: {
                    disconnect: {
                        id: req.params.id
                    }
                }
            }
        });
        res.json(response);
    }
    catch (err) {
        res.status(500).json({ message: "Error leaving event" });
    }
});
export default router;
//# sourceMappingURL=events.js.map