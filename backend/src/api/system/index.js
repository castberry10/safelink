import express from 'express';

const router = express.Router();

const VERSION_MAJOR_THRESHOLD = process.env.VERSION_MAJOR_THRESHOLD;
const VERSION_MINOR_THRESHOLD = process.env.VERSION_MINOR_THRESHOLD;
const VERSION_PATCH_THRESHOLD = process.env.VERSION_PATCH_THRESHOLD;

const VERSION_MAJOR_LATEST = process.env.VERSION_MAJOR_LATEST;
const VERSION_MINOR_LATEST = process.env.VERSION_MINOR_LATEST;
const VERSION_PATCH_LATEST = process.env.VERSION_PATCH_LATEST;

router.post('/version', async (req, res) => {
    const { major_version, minor_version, patch_version } = req.body;
    if (!major_version || !minor_version || !patch_version) {
        return res.status(400).json({ message: 'Bad Request' });
    }
    try {
        if (major_version <= VERSION_MAJOR_THRESHOLD || minor_version <= VERSION_MINOR_THRESHOLD || patch_version <= VERSION_PATCH_THRESHOLD) {
            return res.status(426).json({ message: 'Unauthorized' });
        }
        res.status(200).json({message: `${VERSION_MAJOR_LATEST}.${VERSION_MINOR_LATEST}.${VERSION_PATCH_LATEST}` });
    }
    catch (error) {
        console.error(error);
        res.status(500).json({ message: error.message });
    }
});

export default router;