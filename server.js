const express = require('express');
const path = require('path');
const app = express();
const port = 3000;

app.get('/info', (req, res) => {
    res.json({
        commitMsg: process.env.COMMIT_MSG || '메시지 없음',
        buildTime: new Date().toLocaleString('ko-KR', { timeZone: 'Asia/Seoul' })
    });
});

app.use(express.static(path.join(__dirname, 'public')));
app.listen(port, () => console.log('Server running on ${port}'));
