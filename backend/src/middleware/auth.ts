import { UUID } from "crypto";
import { NextFunction, Request, Response } from "express";
import jwt from "jsonwebtoken";
import { db } from "../db";
import { eq } from "drizzle-orm";
import { users } from "../db/schema";

export interface AuthRequest extends Request {
  user?: UUID;
  token?: String;
}

export const auth = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    // get header
    const token = req.header("x-auth-token");
    if (!token) {
      res.status(401).json({ error: "No Auth Token, access denied!" });
      return;
    }
    // check if the token is valid
    const verified = jwt.verify(token, "passwordKey");

    if (!verified) {
      res.status(401).json({ error: "Token Verification Failed!" });
      return;
    }
    // get the user data if the token is valid
    const verifiedToken = verified as { id: UUID };
    const user = await db
      .select()
      .from(users)
      .where(eq(users.id, verifiedToken.id));
    // if no user return false
    if (!user) {
      res.status(401).json({ error: "User not found!" });
      return;
      }
      
      req.user = verifiedToken.id;
      req.token = token;
    next()
  } catch (e) {
    res.status(500).json(false);
  }
};
