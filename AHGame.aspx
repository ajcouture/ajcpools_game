<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="AHGame.aspx.vb" Inherits="AJC_NCAA.AHGame" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>AJCPools | Dedicated to the Biggest Jackass in Pool History</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />

    <!-- FavIcon Configuration -->
    <link rel="icon" type="image/svg+xml" href="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 32 32'%3E%3Cg transform='rotate(-45 16 16)'%3E%3Cpath d='M2 16C2 6 10 2 16 2s14 4 14 14-8 14-14 14S2 26 2 16z' fill='%238B4513'/%3E%3Cpath d='M16 6v20' stroke='white' stroke-width='2' stroke-linecap='round'/%3E%3Cpath d='M12 11h8M12 16h8M12 21h8' stroke='white' stroke-width='2' stroke-linecap='round'/%3E%3C/g%3E%3C/svg%3E" />

    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <link href="https://fonts.googleapis.com/css2?family=Inter:ital,wght@0,400;0,600;0,700;0,900;1,900&display=swap" rel="stylesheet" />

    <style type="text/css">
        :root {
            --bg-deep: #020617;
            --card-bg: rgba(15, 23, 42, 0.9);
            --accent-teal: #14b8a6;
            --accent-gold: #fbbf24;
            --text-primary: #ffffff;
            --text-body: #e2e8f0;
            --text-muted: #94a3b8;
            --border-color: #1e293b;
            --font-stack: 'Inter', sans-serif;
        }

        *, *::before, *::after { box-sizing: border-box; }

        body, html {
            margin: 0; padding: 0; min-height: 100%;
            background-color: var(--bg-deep); font-family: var(--font-stack); color: var(--text-body);
            background-image: linear-gradient(rgba(255, 255, 255, 0.03) 1px, transparent 1px), linear-gradient(90deg, rgba(255, 255, 255, 0.03) 1px, transparent 1px);
            background-size: 32px 32px;
            user-select: none;
        }

        .page-content { position: relative; z-index: 10; max-width: 950px; margin: 40px auto; padding: 0 20px; }

        .glass-card {
            background: var(--card-bg); backdrop-filter: blur(24px); border: 1px solid var(--border-color);
            box-shadow: 0 8px 32px rgba(0,0,0,0.5); border-radius: 12px; padding: 30px;
        }

        .page-title {
            color: var(--text-primary); font-weight: 900; font-style: italic; text-transform: uppercase;
            letter-spacing: -0.03em; font-size: 24px; margin: 0 0 25px 0; text-shadow: 0 4px 10px rgba(0,0,0,0.5); text-align: center;
        }

        .score-info-panel { 
            display: flex;
            justify-content: space-around;
            background-color: rgba(30, 41, 59, 0.4); border: 1px solid var(--border-color);
            border-radius: 8px; padding: 12px 16px; margin-bottom: 20px; text-align: center;
            font-size: 20px; font-weight: 700; color: var(--text-primary);
        }
        .score-info-panel b { color: var(--accent-gold); font-size: 24px; }
        .score-box { flex: 1; text-align: center; }
        .score-divider { width: 1px; background: var(--border-color); height: 30px; }

        .field-arena-box { 
            display: grid;
            grid-template-columns: 8% 84% 8%; /* Adjusted width ratios for tight vertical text */
            width: 100%; 
            height: 380px; 
            position: relative; 
            border: 4px solid #ffffff;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: inset 0 0 40px rgba(0,0,0,0.5);
        }

        /* Endzones with vertical text orientation */
        .endzone-left, .endzone-right {
            background: #14532d;
            height: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 26px;
            font-weight: 900;
            color: rgba(255, 255, 255, 0.18);
            letter-spacing: 6px;
            writing-mode: vertical-lr; /* Forces text to run vertically */
            text-orientation: upright; /* Keeps letters upright instead of rotated */
        }
        .endzone-left { border-right: 4px solid #ffffff; }
        .endzone-right { border-left: 4px solid #ffffff; }

        .playing-field-grid {
            position: relative;
            background: #15803d;
            background-image: linear-gradient(90deg, #166534 50%, #15803d 50%);
            background-size: 20% 100%;
            height: 100%;
            width: 100%;
        }

        .yard-lines-layer {
            position: absolute; width: 100%; height: 100%; top: 0; left: 0;
            display: flex; justify-content: space-between; pointer-events: none;
        }
        .css-yard-line {
            width: 2px; height: 100%; background: rgba(255, 255, 255, 0.4); position: relative;
        }
        .css-yard-line::before, .css-yard-line::after {
            content: ''; position: absolute; width: 10px; height: 2px; background: rgba(255, 255, 255, 0.4); left: -4px;
        }
        .css-yard-line::before { top: 15px; }
        .css-yard-line::after { bottom: 15px; }

        /* Modified: Centered 50 Yard Marker Overlay styling */
        .field-numbers-layer {
            position: absolute; width: 100%; height: 100%; top: 0; left: 0;
            display: flex; justify-content: center; align-items: center;
            font-size: 36px; font-weight: 800; color: rgba(255, 255, 255, 0.2);
            font-family: monospace; pointer-events: none;
        }
        
        #game-target-wrapper {
            position: absolute;
            width: 85px;
            height: 107px;
            cursor: crosshair;
            z-index: 50;
        }

        #target-img { 
            width: 100%; 
            height: auto; 
            display: block;
            user-drag: none;
            -webkit-user-drag: none;
            filter: drop-shadow(0 4px 8px rgba(0,0,0,0.4));
        }

        #sacked-banner {
            display: none;
            width: 100%;
            height: 100%;
            background: rgba(239, 68, 68, 0.95);
            border: 2px solid var(--accent-gold);
            border-radius: 8px;
            color: var(--accent-gold);
            font-weight: 900;
            font-size: 16px;
            text-align: center;
            text-transform: uppercase;
            align-items: center;
            justify-content: center;
            font-style: italic;
            box-shadow: 0 4px 10px rgba(0,0,0,0.5);
            text-shadow: 1px 1px 2px rgba(0,0,0,0.8);
        }
    </style>
</head>
<body>
    <form id="Form1" method="post" runat="server">
        <uc1:MenuNew ID="MenuNew1" runat="server"></uc1:MenuNew>

        <div class="page-content">
            <div class="glass-card">
                <h1 class="page-title">Dedicated to the Biggest Jackass in Pool History!</h1>
                
                <div class="score-info-panel">
                    <div class="score-box">Your Score: <b><span id="player-score">0</span></b></div>
                    <div class="score-divider"></div>
                    <div class="score-box">Jackass Touchdowns: <b><span id="cpu-score">0</span></b></div>
                </div>

                <div class="field-arena-box" id="arena">
                    <div class="endzone-left">HOME</div>

                    <div class="playing-field-grid" id="playingField">
                        
                        <div class="yard-lines-layer">
                            <div class="css-yard-line"></div><div class="css-yard-line"></div><div class="css-yard-line"></div>
                            <div class="css-yard-line"></div><div class="css-yard-line"></div><div class="css-yard-line"></div>
                            <div class="css-yard-line"></div><div class="css-yard-line"></div><div class="css-yard-line"></div>
                            <div class="css-yard-line"></div><div class="css-yard-line"></div>
                        </div>

                        <!-- Displays only the 50 yard marker directly down the middle axis -->
                        <div class="field-numbers-layer">
                            <div>50</div>
                        </div>

                        <div id="game-target-wrapper">
                            <img id="target-img" src="images/ah/AH.gif" alt="Target" />
                            <div id="sacked-banner">Sacked!</div>
                        </div>

                    </div>

                    <div class="endzone-right">AWAY</div>
                </div>
            </div>
        </div>

        <script type="text/javascript">
            var playerScore = 0;
            var cpuScore = 0;
            var playerDisplay = document.getElementById('player-score');
            var cpuDisplay = document.getElementById('cpu-score');

            var wrapper = document.getElementById('game-target-wrapper');
            var targetImg = document.getElementById('target-img');
            var sackedBanner = document.getElementById('sacked-banner');
            var playingField = document.getElementById('playingField');
            var isHit = false;

            var posX = 0;
            var baseSpeed = 3.5;
            var speedX = baseSpeed;

            function adjustVerticalPosition() {
                var posY = (playingField.offsetHeight / 2) - (wrapper.offsetHeight / 2);
                wrapper.style.top = posY + 'px';
            }

            wrapper.style.left = posX + 'px';
            targetImg.onload = adjustVerticalPosition;

            function updatePhysics() {
                var maxX = playingField.offsetWidth;

                if (!isHit) {
                    posX += speedX;
                }

                if (posX >= maxX) {
                    cpuScore++;
                    cpuDisplay.innerHTML = cpuScore;
                    resetTarget();
                }

                wrapper.style.left = posX + 'px';
                requestAnimationFrame(updatePhysics);
            }

            function resetTarget() {
                posX = -wrapper.offsetWidth;
                adjustVerticalPosition();
            }

            wrapper.addEventListener('click', function () {
                if (isHit) return;
                isHit = true;

                playerScore++;
                playerDisplay.innerHTML = playerScore;

                targetImg.style.display = 'none';
                sackedBanner.style.display = 'flex';

                baseSpeed += 0.5;
                speedX = baseSpeed;

                setTimeout(function () {
                    sackedBanner.style.display = 'none';
                    targetImg.style.display = 'block';
                    resetTarget();
                    isHit = false;
                }, 400);
            });

            requestAnimationFrame(updatePhysics);

            window.addEventListener('resize', function () {
                adjustVerticalPosition();
            });
        </script>
    </form>
</body>
</html>
