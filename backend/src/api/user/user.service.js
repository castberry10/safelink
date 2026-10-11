import db from '../../db.js';

export const getUserByUsername = async (username) => {
    return db.user.findUnique({where: {username}});
}

export const createUser = async (username) => {
    try {
        return await db.user.create({
            data: { username },
        });
    } catch (error) {
        if (error.code === 'P2002') {
            throw new Error('Username already exists');
        }
        throw error;
    }
}