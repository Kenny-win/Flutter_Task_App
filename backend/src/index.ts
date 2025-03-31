import express from 'express'
import authRouter from './routes/auth';
import taskRouter from './routes/task';

const app = express();
const PORT = 8000

app.use(express.json());
app.use("/auth", authRouter);
app.use("/tasks", taskRouter);

app.get('/', (req, res) => {
    res.send("Welcome to my app !")
})
app.listen(PORT, () => {
    console.log(`Server started on port ${PORT}`)
})

