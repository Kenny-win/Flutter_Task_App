import { Router, Request, Response } from "express";
import { db } from "../db";
import { NewUser, users } from "../db/schema";
import { eq } from "drizzle-orm";
import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";
import { auth, AuthRequest } from "../middleware/auth";

const authRouter = Router();

interface SignUpBody {
  name: string;
  email: string;
  password: string;
}

interface LoginBody {
  email: string;
  password: string;
}

authRouter.post(
  "/signup",
  async (req: Request<{}, {}, SignUpBody>, res: Response) => {
    try {
      // get req body
      const { name, email, password } = req.body;
      // check if user already exist
      const existingUser = await db
        .select()
        .from(users)
        .where(eq(users.email, email));
      if (existingUser.length) {
        res
          .status(400)
          .json({ error: "User with the same email already exists!" });
        return;
      }
      // hashedpassword
      const saltRounds = 8; // Jumlah salt rounds (standarnya 10)
      const pass = password; // Password yang akan di-hash

      const hashedPassword = await bcrypt.hash(pass, saltRounds);
      // masukkan data ke tabel user
      const newUser: NewUser = {
        name,
        email,
        password: hashedPassword,
      };
      const [user] = await db.insert(users).values(newUser).returning();
      res.status(201).json(user);
    } catch (e) {
      res.status(500).json({ error: e });
    }
  }
);

authRouter.post(
  "/login",
  async (req: Request<{}, {}, LoginBody>, res: Response) => {
    try {
      // get req body
      const { email, password } = req.body;
      // check if user already exist
      const [existingUser] = await db
        .select()
        .from(users)
        .where(eq(users.email, email));

      if (!existingUser) {
        res.status(400).json({ error: "User with this email doesn't exist!" });
        return;
      }

      const pass = password;
      const isMatch = await bcrypt.compare(pass, existingUser.password);
      // masukkan data ke tabel user

      if (!isMatch) {
        res.status(400).json({ error: "Incorrect Password" });
        return;
      }

      const token = jwt.sign(
        {
          id: existingUser.id,
        },
        "passwordKey"
      );

      res.json({ token, ...existingUser });
    } catch (e) {
      res.status(500).json({ error: e });
    }
  }
);

authRouter.post("/tokenIsValid", async (req, res) => {
  try {
    // get header
    const token = req.header("x-auth-token");
    if (!token) {
      res.json(false);
      return;
    }
    // check if the token is valid
    const verified = jwt.verify(token, "passwordKey");

    if (!verified) {
      res.json(false);
      return;
    }
    // get the user data if the token is valid
    const verifiedToken = verified as { id: string };
    const user = await db
      .select()
      .from(users)
      .where(eq(users.id, verifiedToken.id));
    // if no user return false
    if (!user) {
      res.json(false);
      return;
    }
    res.json(true);
  } catch (e) {
    res.status(500).json(false);
  }
});

authRouter.get("/", auth, async (req: AuthRequest, res) => {
  try {
    if (!req.user) {
      res.status(401).json({ error: "User not found!" });
      return;
    }

    const [user] = await db.select().from(users).where(eq(users.id, req.user));

    res.json({...user, token: req.token});
  } catch (e) {
    res.status(500).json(false);
  }
});

export default authRouter;
