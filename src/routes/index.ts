import { Router } from "express";
import UserController from "../controllers/UserController";

const routers = Router();

routers.get('/users', UserController.index);

export default routers;