const express = require("express");

const app = express();

app.get("/", (req, res) => {
  return res.json({
    message: "hello world!",
    env: process.env,
  });
});

app.listen(process.env.PORT ?? 8080, () => {
  console.log("Listening...");
});
