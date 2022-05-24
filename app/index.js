const express = require("express");

const app = express();

app.get("/", (req, res) => {
  return res.json(process.env);
});

app.listen(process.env.PORT ?? 8080, () => {
  console.log("Listening...");
});
