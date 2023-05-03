import { Request, Response, NextFunction } from "express";

const users = [
	{ name: 'John', email: 'john@example.com' },
];

export default {
	async index(req: Request, res: Response, next: NextFunction) {
		return res.json(users);
	}
}