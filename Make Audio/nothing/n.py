<!DOCTYPE html>
<html>
<head>
    <style>
        body {
            font-family: sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh; /* Full screen height */
            margin: 0;
            transition: background 0.5s; /* Smooth color fade */
        }
        button {
            padding: 15px 30px;
            font-size: 20px;
            cursor: pointer;
            border: none;
            border-radius: 5px;
            background: white;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        button:hover { background: #f0f0f0; }
    </style>
</head>
<body>

    <button onclick="changeColor()">Click Me!</button>

    <script>
        function changeColor() {
            // Generate a random hex color code
            const randomColor = '#' + Math.floor(Math.random()*16777215).toString(16);
            document.body.style.backgroundColor = randomColor;
        }
    </script>

</body>
</html>
