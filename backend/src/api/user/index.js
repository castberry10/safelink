import express from 'express';
import * as UserService from './user.service.js'

const router = express.Router();

router.post('/login', async (req, res) => {
    const { username } = req.body;
    if (!username) {
        return res.status(400).json({ message: 'Bad Request' });
    }

    try {
        const user = await UserService.getUserByUsername(username);
        if (!user) {
            return res.status(401).json({ message: 'Unauthorized' });
        }
        res.status(200).json({ message: 'Login Successed' });
    }
    catch (error) {
        console.error(error);
        res.status(500).json({ message: error.message });
    }
});
router.post('/register', async (req, res) => {
    const { username } = req.body;
    if (!username) {
        return res.status(400).json({ message: 'Bad Request' });
    }
    try {
        await UserService.createUser(username);
        res.status(201).json({ message: 'Created' });
    }
    catch (error) {
        console.error(error);

        res.status(
            error.massage === 'Username already exists' ? 409 :
                500
        ).json({ message: error.message });
    }
});

export default router;