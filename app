<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>VocaAudio - 영단어 맞춤 암기장</title>
    <!-- Tailwind CSS CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- FontAwesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Google Fonts Inter / Noto Sans KR -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=Noto+Sans+KR:wght@400;500;700&display=swap">

    <script>
        tailwind.config = {
            darkMode: 'class',
            theme: {
                extend: {
                    colors: {
                        primary: {
                            50: '#f0f7ff',
                            100: '#e0effe',
                            500: '#0071e3',
                            600: '#005bb5',
                            700: '#00448a'
                        }
                    },
                    fontFamily: {
                        sans: ['Inter', 'Noto Sans KR', 'sans-serif'],
                    }
                }
            }
        }
    </script>

    <style>
        /* Custom audio wave animation */
        @keyframes soundWave {
            0%, 100% { height: 6px; }
            50% { height: 28px; }
        }
        .wave-bar {
            width: 4px;
            background-color: #0071e3;
            border-radius: 2px;
            animation: soundWave 1.2s ease-in-out infinite;
        }
        .wave-bar:nth-child(1) { animation-delay: 0.0s; }
        .wave-bar:nth-child(2) { animation-delay: 0.2s; }
        .wave-bar:nth-child(3) { animation-delay: 0.4s; }
        .wave-bar:nth-child(4) { animation-delay: 0.1s; }
        .wave-bar:nth-child(5) { animation-delay: 0.3s; }

        /* Custom scrollbar */
        ::-webkit-scrollbar { width: 6px; }
        ::-webkit-scrollbar-track { background: transparent; }
        ::-webkit-scrollbar-thumb { background: rgba(156, 163, 175, 0.4); border-radius: 3px; }
    </style>
</head>
<body class="bg-gray-100 dark:bg-gray-900 text-gray-800 dark:text-gray-100 font-sans min-h-screen flex flex-col justify-between transition-colors duration-200">

    <!-- App Header -->
    <header class="w-full max-w-lg mx-auto px-4 py-3 bg-white/80 dark:bg-gray-800/80 backdrop-blur-md sticky top-0 z-30 border-b border-gray-200 dark:border-gray-700 flex justify-between items-center shadow-sm">
        <div class="flex items-center space-x-2">
            <div class="w-9 h-9 rounded-xl bg-primary-500 flex items-center justify-center text-white font-bold text-lg shadow-md shadow-primary-500/30">
                <i class="fa-solid font-bold fa-headphones"></i>
            </div>
            <div>
                <h1 class="font-bold text-base leading-tight tracking-tight">VocaAudio Pro</h1>
                <p class="text-xs text-gray-500 dark:text-gray-400">자동 & 수동 백그라운드 학습기</p>
            </div>
        </div>

        <div class="flex items-center space-x-2">
            <!-- Dark Mode Toggle -->
            <button id="themeToggleBtn" class="p-2 rounded-lg bg-gray-100 dark:bg-gray-700 text-gray-600 dark:text-gray-300 hover:bg-gray-200 dark:hover:bg-gray-600 transition">
                <i class="fa-solid fa-moon text-sm dark:hidden"></i>
                <i class="fa-solid fa-sun text-sm hidden dark:block"></i>
            </button>
            <!-- Manage List Modal Trigger -->
            <button id="openListModalBtn" class="p-2 rounded-lg bg-gray-100 dark:bg-gray-700 text-gray-600 dark:text-gray-300 hover:bg-gray-200 dark:hover:bg-gray-600 transition text-xs font-medium flex items-center space-x-1">
                <i class="fa-solid fa-list-ul"></i>
                <span class="hidden sm:inline">단어목록</span>
            </button>
        </div>
    </header>

    <!-- Main Content Container -->
    <main class="w-full max-w-lg mx-auto px-4 py-4 flex-1 flex flex-col gap-4">

        <!-- Top Bar: Import File & Filter Status -->
        <section class="bg-white dark:bg-gray-800 rounded-2xl p-4 shadow-sm border border-gray-100 dark:border-gray-700">
            <div class="flex justify-between items-center mb-3">
                <div class="flex items-center space-x-2">
                    <span id="fileBadge" class="px-2.5 py-1 text-xs font-semibold rounded-full bg-blue-100 text-blue-700 dark:bg-blue-900/50 dark:text-blue-300">
                        기본 sample.csv
                    </span>
                    <span id="totalWordCount" class="text-xs text-gray-500 dark:text-gray-400 font-medium">총 12단어</span>
                </div>
                <!-- Upload Button -->
                <label for="csvFileInput" class="cursor-pointer text-xs font-semibold text-primary-500 hover:text-primary-600 dark:text-blue-400 flex items-center space-x-1 bg-primary-50 dark:bg-gray-700 px-3 py-1.5 rounded-lg border border-primary-100 dark:border-gray-600 transition">
                    <i class="fa-solid fa-file-arrow-up"></i>
                    <span>단어장 불러오기</span>
                </label>
                <input type="file" id="csvFileInput" accept=".csv, .txt" class="hidden">
            </div>

            <!-- Filter tabs & Shuffle -->
            <div class="flex items-center justify-between pt-2 border-t border-gray-100 dark:border-gray-700 text-xs">
                <div class="flex space-x-1 bg-gray-100 dark:bg-gray-700 p-1 rounded-lg">
                    <button id="filterAllBtn" class="px-3 py-1 rounded-md font-medium transition bg-white dark:bg-gray-600 text-gray-800 dark:text-white shadow-xs">전체</button>
                    <button id="filterBookmarkBtn" class="px-3 py-1 rounded-md font-medium text-gray-500 dark:text-gray-400 hover:text-gray-800 dark:hover:text-white transition">⭐ 북마크</button>
                    <button id="filterUnlearnedBtn" class="px-3 py-1 rounded-md font-medium text-gray-500 dark:text-gray-400 hover:text-gray-800 dark:hover:text-white transition">미암기</button>
                </div>
                
                <button id="shuffleBtn" class="px-3 py-1.5 rounded-lg text-gray-600 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700 font-medium flex items-center space-x-1 border border-gray-200 dark:border-gray-600 transition">
                    <i class="fa-solid fa-shuffle text-xs"></i>
                    <span>셔플</span>
                </button>
            </div>
        </section>

        <!-- Mode Selector Bar -->
        <section class="bg-white dark:bg-gray-800 rounded-2xl p-2 shadow-sm border border-gray-100 dark:border-gray-700 flex text-xs font-semibold">
            <button id="autoModeBtn" class="flex-1 py-2.5 rounded-xl bg-primary-500 text-white flex items-center justify-center space-x-2 transition shadow-sm">
                <i class="fa-solid fa-robot"></i>
                <span>자동 재생 모드</span>
            </button>
            <button id="manualModeBtn" class="flex-1 py-2.5 rounded-xl text-gray-500 dark:text-gray-400 hover:text-gray-800 dark:hover:text-white flex items-center justify-center space-x-2 transition">
                <i class="fa-solid fa-hand-pointer"></i>
                <span>수동 암기 모드</span>
            </button>
        </section>

        <!-- Flashcard Display Area -->
        <section class="flex-1 flex flex-col items-center justify-center relative min-h-[260px]">
            <div id="flashCard" class="w-full h-full min-h-[260px] bg-white dark:bg-gray-800 rounded-3xl p-6 shadow-md border border-gray-100 dark:border-gray-700 flex flex-col justify-between items-center relative transition-all duration-300 cursor-pointer select-none">
                
                <!-- Top Card Bar -->
                <div class="w-full flex justify-between items-center text-xs text-gray-400">
                    <span id="cardProgress" class="font-semibold text-primary-500 dark:text-blue-400">1 / 12</span>
                    <div class="flex items-center space-x-3">
                        <button id="starCurrentBtn" class="text-gray-300 dark:text-gray-600 hover:text-amber-400 text-lg transition">
                            <i class="fa-solid fa-star"></i>
                        </button>
                        <button id="checkMemorizedBtn" class="text-gray-300 dark:text-gray-600 hover:text-emerald-500 text-lg transition" title="외움 표시">
                            <i class="fa-solid fa-circle-check"></i>
                        </button>
                    </div>
                </div>

                <!-- Center Text Area -->
                <div class="text-center my-auto py-4 w-full">
                    <div id="wordDisplay" class="text-3xl sm:text-4xl font-extrabold text-gray-900 dark:text-white tracking-tight mb-3">
                        apple
                    </div>
                    <div id="meaningDisplay" class="text-lg sm:text-xl font-medium text-gray-600 dark:text-gray-300 transition-opacity duration-200">
                        사과
                    </div>
                </div>

                <!-- Bottom Status Indicator -->
                <div class="w-full flex justify-between items-center pt-2">
                    <div class="flex items-center space-x-1.5 h-7">
                        <div id="waveContainer" class="flex items-center space-x-1 h-6 hidden">
                            <div class="wave-bar"></div>
                            <div class="wave-bar"></div>
                            <div class="wave-bar"></div>
                            <div class="wave-bar"></div>
                            <div class="wave-bar"></div>
                        </div>
                        <span id="ttsSpeakerStatus" class="text-xs text-gray-400 font-medium ml-1">대기 중</span>
                    </div>

                    <button id="speakSingleBtn" class="p-2 rounded-full bg-primary-50 dark:bg-gray-700 text-primary-500 dark:text-blue-400 hover:bg-primary-100 transition" title="다시 듣기">
                        <i class="fa-solid fa-volume-high text-sm"></i>
                    </button>
                </div>
            </div>
        </section>

        <!-- Player Controls Panel -->
        <section class="bg-white dark:bg-gray-800 rounded-2xl p-4 shadow-sm border border-gray-100 dark:border-gray-700">
            <!-- Audio Controller Buttons -->
            <div class="flex items-center justify-between mb-3 px-2">
                <button id="prevBtn" class="w-12 h-12 rounded-2xl bg-gray-100 dark:bg-gray-700 text-gray-700 dark:text-gray-200 hover:bg-gray-200 dark:hover:bg-gray-600 flex items-center justify-center transition active:scale-95">
                    <i class="fa-solid fa-backward-step text-lg"></i>
                </button>

                <!-- Big Play / Step Trigger Button -->
                <button id="playPauseBtn" class="h-14 px-6 rounded-2xl bg-primary-500 hover:bg-primary-600 text-white shadow-lg shadow-primary-500/40 flex items-center justify-center space-x-2 transition active:scale-95 font-bold text-sm">
                    <i id="playIcon" class="fa-solid fa-play text-xl"></i>
                    <i id="pauseIcon" class="fa-solid fa-pause text-xl hidden"></i>
                    <span id="playBtnText">재생 시작</span>
                </button>

                <button id="nextBtn" class="w-12 h-12 rounded-2xl bg-gray-100 dark:bg-gray-700 text-gray-700 dark:text-gray-200 hover:bg-gray-200 dark:hover:bg-gray-600 flex items-center justify-center transition active:scale-95">
                    <i class="fa-solid fa-forward-step text-lg"></i>
                </button>
            </div>

            <!-- Manual Step Trigger Sub-button (Visible in Manual Mode) -->
            <div id="manualActionContainer" class="mb-3 hidden">
                <button id="manualStepBtn" class="w-full py-3 bg-emerald-500 hover:bg-emerald-600 text-white font-bold rounded-xl shadow-md transition flex items-center justify-center space-x-2 text-xs">
                    <i class="fa-solid fa-eye"></i>
                    <span id="manualStepBtnText">뜻 확인 및 재생 (다음 단계)</span>
                </button>
            </div>

            <!-- Separate Repeat & Speed Settings -->
            <div class="grid grid-cols-2 gap-3 pt-3 border-t border-gray-100 dark:border-gray-700 text-xs">
                <!-- Word Repeat Count -->
                <div class="flex flex-col space-y-1">
                    <label for="wordRepeatSelect" class="text-gray-500 dark:text-gray-400 font-medium">단어 발음 반복</label>
                    <select id="wordRepeatSelect" class="w-full bg-gray-50 dark:bg-gray-700 border border-gray-200 dark:border-gray-600 rounded-lg p-2 font-medium text-gray-700 dark:text-gray-200 focus:outline-none focus:border-primary-500">
                        <option value="1">1회 반복</option>
                        <option value="2" selected>2회 반복</option>
                        <option value="3">3회 반복</option>
                        <option value="4">4회 반복</option>
                        <option value="5">5회 반복</option>
                    </select>
                </div>

                <!-- Meaning Repeat Count -->
                <div class="flex flex-col space-y-1">
                    <label for="meaningRepeatSelect" class="text-gray-500 dark:text-gray-400 font-medium">한국어 뜻 반복</label>
                    <select id="meaningRepeatSelect" class="w-full bg-gray-50 dark:bg-gray-700 border border-gray-200 dark:border-gray-600 rounded-lg p-2 font-medium text-gray-700 dark:text-gray-200 focus:outline-none focus:border-primary-500">
                        <option value="1" selected>1회 반복</option>
                        <option value="2">2회 반복</option>
                        <option value="3">3회 반복</option>
                        <option value="4">4회 반복</option>
                        <option value="5">5회 반복</option>
                    </select>
                </div>

                <!-- Speed Selection -->
                <div class="flex flex-col space-y-1">
                    <label for="speedSelect" class="text-gray-500 dark:text-gray-400 font-medium">재생 속도</label>
                    <select id="speedSelect" class="w-full bg-gray-50 dark:bg-gray-700 border border-gray-200 dark:border-gray-600 rounded-lg p-2 font-medium text-gray-700 dark:text-gray-200 focus:outline-none focus:border-primary-500">
                        <option value="0.8">0.8x (느리게)</option>
                        <option value="1.0" selected>1.0x (보통)</option>
                        <option value="1.2">1.2x (빠르게)</option>
                        <option value="1.5">1.5x (매우 빠르게)</option>
                    </select>
                </div>

                <!-- Delay Interval -->
                <div class="flex flex-col space-y-1">
                    <label for="delaySelect" class="text-gray-500 dark:text-gray-400 font-medium">자동 모드 간격</label>
                    <select id="delaySelect" class="w-full bg-gray-50 dark:bg-gray-700 border border-gray-200 dark:border-gray-600 rounded-lg p-2 font-medium text-gray-700 dark:text-gray-200 focus:outline-none focus:border-primary-500">
                        <option value="1000">1초 간격</option>
                        <option value="2000" selected>2초 간격</option>
                        <option value="3000">3초 간격</option>
                        <option value="5000">5초 간격</option>
                    </select>
                </div>
            </div>

            <!-- Lock Screen Step Hint -->
            <div id="manualLockscreenHint" class="mt-3 pt-2 border-t border-gray-100 dark:border-gray-700 text-[11px] text-gray-500 dark:text-gray-400 hidden flex items-center space-x-1.5">
                <i class="fa-solid fa-circle-info text-primary-500"></i>
                <span>수동 모드는 잠금화면/이어폰의 <b>'다음 곡(▶▶|)'</b> 버튼으로 백그라운드 넘어감 지원!</span>
            </div>
        </section>

    </main>

    <!-- Footer Information -->
    <footer class="w-full max-w-lg mx-auto px-4 py-3 text-center text-xs text-gray-400 dark:text-gray-500">
        🎧 백그라운드 무음 트랙 및 Media Session API 동작 중
    </footer>

    <!-- Word List Management Modal -->
    <div id="wordListModal" class="fixed inset-0 bg-black/50 backdrop-blur-xs z-50 flex items-end sm:items-center justify-center p-0 sm:p-4 hidden transition-opacity">
        <div class="bg-white dark:bg-gray-800 w-full max-w-lg rounded-t-3xl sm:rounded-3xl max-h-[85vh] flex flex-col shadow-2xl overflow-hidden">
            <div class="p-4 border-b border-gray-200 dark:border-gray-700 flex justify-between items-center">
                <h3 class="font-bold text-base text-gray-900 dark:text-white flex items-center space-x-2">
                    <i class="fa-solid fa-book-open text-primary-500"></i>
                    <span>현재 단어목록 관리</span>
                </h3>
                <button id="closeListModalBtn" class="p-1.5 rounded-lg text-gray-400 hover:text-gray-600 dark:hover:text-gray-200">
                    <i class="fa-solid fa-xmark text-lg"></i>
                </button>
            </div>

            <div id="modalWordListContainer" class="p-4 overflow-y-auto flex-1 divide-y divide-gray-100 dark:divide-gray-700"></div>

            <div class="p-4 bg-gray-50 dark:bg-gray-900 border-t border-gray-200 dark:border-gray-700 flex justify-between items-center">
                <button id="resetSampleDataBtn" class="text-xs text-gray-500 hover:text-gray-800 dark:text-gray-400 dark:hover:text-white underline">
                    기본 샘플 데이터로 복원
                </button>
                <button id="closeModalBottomBtn" class="px-4 py-2 bg-primary-500 text-white rounded-xl text-xs font-semibold hover:bg-primary-600 transition">
                    닫기
                </button>
            </div>
        </div>
    </div>

    <!-- Hidden Silent Audio Element for Continuous Background Session -->
    <audio id="silentAudioTrack" loop preload="auto" src="data:audio/wav;base64,UklGRigAAABXQVZFZm10IBAAAAABAAEARKwAAIhYAQACABAAZGF0YQAAAAA="></audio>

    <!-- Application Logic -->
    <script>
        const SAMPLE_WORDS = [
            { id: 1, word: "accomplish", meaning: "성취하다, 완수하다", bookmarked: false, memorized: false },
            { id: 2, word: "benevolent", meaning: "자애로운, 자선의", bookmarked: true, memorized: false },
            { id: 3, word: "candidate", meaning: "후보자, 지원자", bookmarked: false, memorized: false },
            { id: 4, word: "deliberate", meaning: "의도적인, 숙고하다", bookmarked: false, memorized: true },
            { id: 5, word: "eloquent", meaning: "유창한, 감동적인", bookmarked: true, memorized: false },
            { id: 6, word: "fascinate", meaning: "매료시키다, 사로잡다", bookmarked: false, memorized: false },
            { id: 7, word: "genuine", meaning: "진짜의, 진실한", bookmarked: false, memorized: false },
            { id: 8, word: "hesitate", meaning: "망설이다, 주저하다", bookmarked: false, memorized: false },
            { id: 9, word: "inevitable", meaning: "피할 수 없는, 불가피한", bookmarked: true, memorized: false },
            { id: 10, word: "justify", meaning: "정당화하다", bookmarked: false, memorized: false }
        ];

        // State variables
        let masterWordsList = JSON.parse(localStorage.getItem('voca_words')) || [...SAMPLE_WORDS];
        let activeFilter = 'ALL';
        let currentFilteredList = [];
        let currentIndex = 0;
        
        let playMode = 'AUTO'; // 'AUTO' or 'MANUAL'
        let manualStep = 'WORD'; // In manual mode: 'WORD' or 'MEANING'
        let isPlaying = false;
        let playbackTimeout = null;

        // Elements
        const wordDisplay = document.getElementById('wordDisplay');
        const meaningDisplay = document.getElementById('meaningDisplay');
        const cardProgress = document.getElementById('cardProgress');
        const playPauseBtn = document.getElementById('playPauseBtn');
        const playIcon = document.getElementById('playIcon');
        const pauseIcon = document.getElementById('pauseIcon');
        const playBtnText = document.getElementById('playBtnText');
        const prevBtn = document.getElementById('prevBtn');
        const nextBtn = document.getElementById('nextBtn');
        const starCurrentBtn = document.getElementById('starCurrentBtn');
        const checkMemorizedBtn = document.getElementById('checkMemorizedBtn');
        const waveContainer = document.getElementById('waveContainer');
        const ttsSpeakerStatus = document.getElementById('ttsSpeakerStatus');
        
        const autoModeBtn = document.getElementById('autoModeBtn');
        const manualModeBtn = document.getElementById('manualModeBtn');
        const manualActionContainer = document.getElementById('manualActionContainer');
        const manualStepBtn = document.getElementById('manualStepBtn');
        const manualStepBtnText = document.getElementById('manualStepBtnText');
        const manualLockscreenHint = document.getElementById('manualLockscreenHint');

        const wordRepeatSelect = document.getElementById('wordRepeatSelect');
        const meaningRepeatSelect = document.getElementById('meaningRepeatSelect');
        const speedSelect = document.getElementById('speedSelect');
        const delaySelect = document.getElementById('delaySelect');

        const csvFileInput = document.getElementById('csvFileInput');
        const totalWordCount = document.getElementById('totalWordCount');
        const fileBadge = document.getElementById('fileBadge');
        const silentAudioTrack = document.getElementById('silentAudioTrack');
        const speakSingleBtn = document.getElementById('speakSingleBtn');

        const filterAllBtn = document.getElementById('filterAllBtn');
        const filterBookmarkBtn = document.getElementById('filterBookmarkBtn');
        const filterUnlearnedBtn = document.getElementById('filterUnlearnedBtn');
        const shuffleBtn = document.getElementById('shuffleBtn');

        const openListModalBtn = document.getElementById('openListModalBtn');
        const closeListModalBtn = document.getElementById('closeListModalBtn');
        const closeModalBottomBtn = document.getElementById('closeModalBottomBtn');
        const wordListModal = document.getElementById('wordListModal');
        const modalWordListContainer = document.getElementById('modalWordListContainer');
        const resetSampleDataBtn = document.getElementById('resetSampleDataBtn');
        const themeToggleBtn = document.getElementById('themeToggleBtn');

        function initApp() {
            applyFilter('ALL');
            setupEventListeners();
            setupMediaSession();
            checkSystemTheme();
        }

        function saveToStorage() {
            localStorage.setItem('voca_words', JSON.stringify(masterWordsList));
        }

        function applyFilter(filterType) {
            activeFilter = filterType;
            if (filterType === 'BOOKMARK') {
                currentFilteredList = masterWordsList.filter(w => w.bookmarked);
            } else if (filterType === 'UNLEARNED') {
                currentFilteredList = masterWordsList.filter(w => !w.memorized);
            } else {
                currentFilteredList = [...masterWordsList];
            }

            [filterAllBtn, filterBookmarkBtn, filterUnlearnedBtn].forEach(btn => {
                btn.className = "px-3 py-1 rounded-md font-medium text-gray-500 dark:text-gray-400 hover:text-gray-800 dark:hover:text-white transition";
            });

            if (filterType === 'ALL') {
                filterAllBtn.className = "px-3 py-1 rounded-md font-medium transition bg-white dark:bg-gray-600 text-gray-800 dark:text-white shadow-xs";
            } else if (filterType === 'BOOKMARK') {
                filterBookmarkBtn.className = "px-3 py-1 rounded-md font-medium transition bg-white dark:bg-gray-600 text-amber-500 dark:text-amber-300 shadow-xs";
            } else if (filterType === 'UNLEARNED') {
                filterUnlearnedBtn.className = "px-3 py-1 rounded-md font-medium transition bg-white dark:bg-gray-600 text-blue-600 dark:text-blue-300 shadow-xs";
            }

            currentIndex = 0;
            manualStep = 'WORD';
            updateCardDisplay();
            totalWordCount.textContent = `총 ${currentFilteredList.length}개 단어`;
        }

        function updateCardDisplay() {
            if (currentFilteredList.length === 0) {
                wordDisplay.textContent = "단어 없음";
                meaningDisplay.textContent = "조건에 해당하는 단어가 없습니다.";
                meaningDisplay.style.opacity = "1";
                cardProgress.textContent = "0 / 0";
                return;
            }

            if (currentIndex >= currentFilteredList.length) currentIndex = 0;

            const current = currentFilteredList[currentIndex];
            wordDisplay.textContent = current.word;
            meaningDisplay.textContent = current.meaning;

            // In Manual Mode step 1, hide meaning until revealed
            if (playMode === 'MANUAL' && manualStep === 'WORD') {
                meaningDisplay.style.opacity = "0.15";
            } else {
                meaningDisplay.style.opacity = "1";
            }

            cardProgress.textContent = `${currentIndex + 1} / ${currentFilteredList.length}`;

            starCurrentBtn.className = current.bookmarked 
                ? "text-amber-400 text-lg transition scale-110" 
                : "text-gray-300 dark:text-gray-600 hover:text-amber-400 text-lg transition";

            checkMemorizedBtn.className = current.memorized 
                ? "text-emerald-500 text-lg transition scale-110" 
                : "text-gray-300 dark:text-gray-600 hover:text-emerald-500 text-lg transition";

            updateMediaSessionMetadata(current);
        }

        // Switch Mode (Auto vs Manual)
        function setPlayMode(mode) {
            stopPlayback();
            playMode = mode;
            manualStep = 'WORD';

            if (mode === 'AUTO') {
                autoModeBtn.className = "flex-1 py-2.5 rounded-xl bg-primary-500 text-white flex items-center justify-center space-x-2 transition shadow-sm font-semibold";
                manualModeBtn.className = "flex-1 py-2.5 rounded-xl text-gray-500 dark:text-gray-400 hover:text-gray-800 dark:hover:text-white flex items-center justify-center space-x-2 transition font-semibold";
                manualActionContainer.classList.add('hidden');
                manualLockscreenHint.classList.add('hidden');
                playBtnText.textContent = "자동 재생 시작";
            } else {
                manualModeBtn.className = "flex-1 py-2.5 rounded-xl bg-emerald-500 text-white flex items-center justify-center space-x-2 transition shadow-sm font-semibold";
                autoModeBtn.className = "flex-1 py-2.5 rounded-xl text-gray-500 dark:text-gray-400 hover:text-gray-800 dark:hover:text-white flex items-center justify-center space-x-2 transition font-semibold";
                manualActionContainer.classList.remove('hidden');
                manualLockscreenHint.classList.remove('hidden');
                playBtnText.textContent = "단어 발음 시작";
                manualStepBtnText.textContent = "뜻 확인 및 재생";
            }

            updateCardDisplay();
        }

        // AUTO PLAYBACK SEQUENCE
        function startAutoSequence() {
            if (!isPlaying || currentFilteredList.length === 0) return;

            window.speechSynthesis.cancel();
            if (playbackTimeout) clearTimeout(playbackTimeout);

            const current = currentFilteredList[currentIndex];
            updateCardDisplay();

            const speed = parseFloat(speedSelect.value);
            const wordRepeats = parseInt(wordRepeatSelect.value);
            const meaningRepeats = parseInt(meaningRepeatSelect.value);
            const delay = parseInt(delaySelect.value);

            let count = 0;

            function speakWordLoop() {
                if (!isPlaying) return;
                setAudioPlayingUI(true, `단어 발음 (${count + 1}/${wordRepeats})`);

                const utt = new SpeechSynthesisUtterance(current.word);
                utt.lang = 'en-US';
                utt.rate = speed;

                utt.onend = () => {
                    count++;
                    if (count < wordRepeats) {
                        playbackTimeout = setTimeout(speakWordLoop, 400);
                    } else {
                        count = 0;
                        playbackTimeout = setTimeout(speakMeaningLoop, 500);
                    }
                };
                utt.onerror = () => { playbackTimeout = setTimeout(nextAutoWord, 500); };

                window.speechSynthesis.speak(utt);
            }

            function speakMeaningLoop() {
                if (!isPlaying) return;
                setAudioPlayingUI(true, `뜻 읽기 (${count + 1}/${meaningRepeats})`);

                const utt = new SpeechSynthesisUtterance(current.meaning);
                utt.lang = 'ko-KR';
                utt.rate = speed;

                utt.onend = () => {
                    count++;
                    if (count < meaningRepeats) {
                        playbackTimeout = setTimeout(speakMeaningLoop, 400);
                    } else {
                        setAudioPlayingUI(false, "대기 중");
                        playbackTimeout = setTimeout(nextAutoWord, delay);
                    }
                };
                utt.onerror = () => { nextAutoWord(); };

                window.speechSynthesis.speak(utt);
            }

            function nextAutoWord() {
                if (!isPlaying) return;
                currentIndex++;
                if (currentIndex >= currentFilteredList.length) currentIndex = 0;
                startAutoSequence();
            }

            speakWordLoop();
        }

        // MANUAL PLAYBACK STEPS
        function playManualWordStep() {
            if (currentFilteredList.length === 0) return;
            window.speechSynthesis.cancel();
            if (playbackTimeout) clearTimeout(playbackTimeout);

            manualStep = 'WORD';
            updateCardDisplay();

            const current = currentFilteredList[currentIndex];
            const speed = parseFloat(speedSelect.value);
            const wordRepeats = parseInt(wordRepeatSelect.value);
            let count = 0;

            isPlaying = true;
            playIcon.classList.add('hidden');
            pauseIcon.classList.remove('hidden');
            silentAudioTrack.play().catch(e => console.log(e));

            function loop() {
                setAudioPlayingUI(true, `단어 발음 (${count + 1}/${wordRepeats})`);
                const utt = new SpeechSynthesisUtterance(current.word);
                utt.lang = 'en-US';
                utt.rate = speed;

                utt.onend = () => {
                    count++;
                    if (count < wordRepeats) {
                        playbackTimeout = setTimeout(loop, 400);
                    } else {
                        setAudioPlayingUI(false, "뜻 생각 시간 (수동 대기)");
                        manualStepBtnText.textContent = "뜻 확인 및 재생 (다음)";
                    }
                };
                window.speechSynthesis.speak(utt);
            }

            loop();
        }

        function playManualMeaningStep() {
            if (currentFilteredList.length === 0) return;
            window.speechSynthesis.cancel();
            if (playbackTimeout) clearTimeout(playbackTimeout);

            manualStep = 'MEANING';
            updateCardDisplay(); // Reveals meaning text

            const current = currentFilteredList[currentIndex];
            const speed = parseFloat(speedSelect.value);
            const meaningRepeats = parseInt(meaningRepeatSelect.value);
            let count = 0;

            function loop() {
                setAudioPlayingUI(true, `뜻 읽기 (${count + 1}/${meaningRepeats})`);
                const utt = new SpeechSynthesisUtterance(current.meaning);
                utt.lang = 'ko-KR';
                utt.rate = speed;

                utt.onend = () => {
                    count++;
                    if (count < meaningRepeats) {
                        playbackTimeout = setTimeout(loop, 400);
                    } else {
                        setAudioPlayingUI(false, "다음 단어로 넘어갈 준비 완료");
                        manualStepBtnText.textContent = "다음 단어로 넘어가기 ▶";
                    }
                };
                window.speechSynthesis.speak(utt);
            }

            loop();
        }

        // Trigger step for Manual mode (Works from screen OR background earphone next track)
        function triggerManualAdvance() {
            if (playMode !== 'MANUAL') return;

            if (manualStep === 'WORD') {
                playManualMeaningStep();
            } else {
                currentIndex++;
                if (currentIndex >= currentFilteredList.length) currentIndex = 0;
                playManualWordStep();
            }
        }

        function startPlayback() {
            if (currentFilteredList.length === 0) return;
            isPlaying = true;
            playIcon.classList.add('hidden');
            pauseIcon.classList.remove('hidden');
            silentAudioTrack.play().catch(e => console.log(e));

            if (playMode === 'AUTO') {
                startAutoSequence();
            } else {
                playManualWordStep();
            }
        }

        function stopPlayback() {
            isPlaying = false;
            playIcon.classList.remove('hidden');
            pauseIcon.classList.add('hidden');
            window.speechSynthesis.cancel();
            if (playbackTimeout) clearTimeout(playbackTimeout);
            silentAudioTrack.pause();
            setAudioPlayingUI(false, "일시정지됨");
        }

        function setAudioPlayingUI(isSpeaking, statusText) {
            ttsSpeakerStatus.textContent = statusText;
            if (isSpeaking) {
                waveContainer.classList.remove('hidden');
            } else {
                waveContainer.classList.add('hidden');
            }
        }

        // Media Session API for Lock Screen Step Control
        function setupMediaSession() {
            if ('mediaSession' in navigator) {
                navigator.mediaSession.setActionHandler('play', () => {
                    startPlayback();
                });
                navigator.mediaSession.setActionHandler('pause', () => {
                    stopPlayback();
                });
                navigator.mediaSession.setActionHandler('previoustrack', () => {
                    handlePrevWord();
                });
                navigator.mediaSession.setActionHandler('nexttrack', () => {
                    if (playMode === 'MANUAL') {
                        triggerManualAdvance();
                    } else {
                        handleNextWord();
                    }
                });
            }
        }

        function updateMediaSessionMetadata(wordObj) {
            if ('mediaSession' in navigator && wordObj) {
                navigator.mediaSession.metadata = new MediaMetadata({
                    title: wordObj.word,
                    artist: playMode === 'MANUAL' && manualStep === 'WORD' ? '뜻을 떠올려보세요' : wordObj.meaning,
                    album: playMode === 'AUTO' ? 'VocaAudio (자동모드)' : 'VocaAudio (수동모드)'
                });
            }
        }

        function handleNextWord() {
            if (currentFilteredList.length === 0) return;
            stopPlayback();
            currentIndex++;
            if (currentIndex >= currentFilteredList.length) currentIndex = 0;
            manualStep = 'WORD';
            updateCardDisplay();
            if (playMode === 'AUTO') startPlayback();
        }

        function handlePrevWord() {
            if (currentFilteredList.length === 0) return;
            stopPlayback();
            currentIndex--;
            if (currentIndex < 0) currentIndex = currentFilteredList.length - 1;
            manualStep = 'WORD';
            updateCardDisplay();
            if (playMode === 'AUTO') startPlayback();
        }

        function handleFileUpload(e) {
            const file = e.target.files[0];
            if (!file) return;

            const reader = new FileReader();
            reader.onload = function(event) {
                parseAndSetVocabularyData(event.target.result, file.name);
            };
            reader.readAsText(file);
        }

        function parseAndSetVocabularyData(text, fileName) {
            const lines = text.split(/\r?\n/);
            const newWords = [];
            let autoId = 1;

            lines.forEach(line => {
                const trimmed = line.trim();
                if (!trimmed) return;
                const parts = trimmed.split(/[,;\t]/);
                if (parts.length >= 2) {
                    const word = parts[0].trim();
                    const meaning = parts.slice(1).join(',').trim();
                    if (word && meaning) {
                        newWords.push({ id: autoId++, word, meaning, bookmarked: false, memorized: false });
                    }
                }
            });

            if (newWords.length > 0) {
                masterWordsList = newWords;
                saveToStorage();
                fileBadge.textContent = fileName;
                applyFilter('ALL');
                alert(`성공적으로 ${newWords.length}개의 단어를 불러왔습니다.`);
            } else {
                alert('단어를 불러오지 못했습니다. "단어, 뜻" (한 줄에 하나씩) 형식을 확인해주세요.');
            }
        }

        function renderModalWordList() {
            modalWordListContainer.innerHTML = '';
            if (masterWordsList.length === 0) {
                modalWordListContainer.innerHTML = '<div class="text-center py-8 text-gray-400 text-xs">등록된 단어가 없습니다.</div>';
                return;
            }

            masterWordsList.forEach((item, index) => {
                const row = document.createElement('div');
                row.className = "py-3 flex items-center justify-between hover:bg-gray-50 dark:hover:bg-gray-700/50 px-2 rounded-lg transition text-xs";
                row.innerHTML = `
                    <div class="flex items-center space-x-3 overflow-hidden">
                        <span class="text-gray-400 font-mono text-[10px] w-6">${index + 1}</span>
                        <div class="truncate">
                            <div class="font-bold text-gray-800 dark:text-gray-200 text-sm truncate">${item.word}</div>
                            <div class="text-gray-500 dark:text-gray-400 truncate">${item.meaning}</div>
                        </div>
                    </div>
                    <div class="flex items-center space-x-2 shrink-0">
                        <button onclick="toggleItemStar(${item.id})" class="${item.bookmarked ? 'text-amber-400' : 'text-gray-300 dark:text-gray-600'} hover:text-amber-400 text-base p-1">
                            <i class="fa-solid fa-star"></i>
                        </button>
                        <button onclick="toggleItemMemorized(${item.id})" class="${item.memorized ? 'text-emerald-500' : 'text-gray-300 dark:text-gray-600'} hover:text-emerald-500 text-base p-1">
                            <i class="fa-solid fa-circle-check"></i>
                        </button>
                        <button onclick="deleteWordItem(${item.id})" class="text-gray-300 dark:text-gray-600 hover:text-rose-500 text-base p-1">
                            <i class="fa-solid fa-trash"></i>
                        </button>
                    </div>
                `;
                modalWordListContainer.appendChild(row);
            });
        }

        window.toggleItemStar = function(id) {
            const target = masterWordsList.find(w => w.id === id);
            if (target) {
                target.bookmarked = !target.bookmarked;
                saveToStorage();
                applyFilter(activeFilter);
                renderModalWordList();
            }
        };

        window.toggleItemMemorized = function(id) {
            const target = masterWordsList.find(w => w.id === id);
            if (target) {
                target.memorized = !target.memorized;
                saveToStorage();
                applyFilter(activeFilter);
                renderModalWordList();
            }
        };

        window.deleteWordItem = function(id) {
            masterWordsList = masterWordsList.filter(w => w.id !== id);
            saveToStorage();
            applyFilter(activeFilter);
            renderModalWordList();
        };

        function checkSystemTheme() {
            if (localStorage.theme === 'dark' || (!('theme' in localStorage) && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
                document.documentElement.classList.add('dark');
            } else {
                document.documentElement.classList.remove('dark');
            }
        }

        themeToggleBtn.addEventListener('click', () => {
            if (document.documentElement.classList.contains('dark')) {
                document.documentElement.classList.remove('dark');
                localStorage.theme = 'light';
            } else {
                document.documentElement.classList.add('dark');
                localStorage.theme = 'dark';
            }
        });

        function setupEventListeners() {
            autoModeBtn.addEventListener('click', () => setPlayMode('AUTO'));
            manualModeBtn.addEventListener('click', () => setPlayMode('MANUAL'));

            playPauseBtn.addEventListener('click', () => {
                if (isPlaying) {
                    stopPlayback();
                } else {
                    startPlayback();
                }
            });

            manualStepBtn.addEventListener('click', () => {
                if (!isPlaying) startPlayback();
                else triggerManualAdvance();
            });

            prevBtn.addEventListener('click', handlePrevWord);
            nextBtn.addEventListener('click', handleNextWord);

            speakSingleBtn.addEventListener('click', () => {
                if (currentFilteredList.length === 0) return;
                window.speechSynthesis.cancel();
                const current = currentFilteredList[currentIndex];
                const speed = parseFloat(speedSelect.value);

                const wordUtt = new SpeechSynthesisUtterance(current.word);
                wordUtt.lang = 'en-US';
                wordUtt.rate = speed;
                window.speechSynthesis.speak(wordUtt);
            });

            starCurrentBtn.addEventListener('click', (e) => {
                e.stopPropagation();
                if (currentFilteredList.length === 0) return;
                const current = currentFilteredList[currentIndex];
                current.bookmarked = !current.bookmarked;
                saveToStorage();
                updateCardDisplay();
            });

            checkMemorizedBtn.addEventListener('click', (e) => {
                e.stopPropagation();
                if (currentFilteredList.length === 0) return;
                const current = currentFilteredList[currentIndex];
                current.memorized = !current.memorized;
                saveToStorage();
                updateCardDisplay();
            });

            // Flashcard click triggers manual advance in manual mode or speaks in auto mode
            document.getElementById('flashCard').addEventListener('click', (e) => {
                if (e.target.closest('button')) return;
                if (playMode === 'MANUAL') {
                    if (!isPlaying) startPlayback();
                    else triggerManualAdvance();
                } else {
                    speakSingleBtn.click();
                }
            });

            csvFileInput.addEventListener('change', handleFileUpload);
            filterAllBtn.addEventListener('click', () => applyFilter('ALL'));
            filterBookmarkBtn.addEventListener('click', () => applyFilter('BOOKMARK'));
            filterUnlearnedBtn.addEventListener('click', () => applyFilter('UNLEARNED'));

            shuffleBtn.addEventListener('click', () => {
                for (let i = currentFilteredList.length - 1; i > 0; i--) {
                    const j = Math.floor(Math.random() * (i + 1));
                    [currentFilteredList[i], currentFilteredList[j]] = [currentFilteredList[j], currentFilteredList[i]];
                }
                currentIndex = 0;
                manualStep = 'WORD';
                updateCardDisplay();
            });

            openListModalBtn.addEventListener('click', () => {
                renderModalWordList();
                wordListModal.classList.remove('hidden');
            });

            closeListModalBtn.addEventListener('click', () => wordListModal.classList.add('hidden'));
            closeModalBottomBtn.addEventListener('click', () => wordListModal.classList.add('hidden'));

            resetSampleDataBtn.addEventListener('click', () => {
                if (confirm('기본 샘플 단어장 데이터로 복원하시겠습니까?')) {
                    masterWordsList = [...SAMPLE_WORDS];
                    saveToStorage();
                    fileBadge.textContent = "기본 sample.csv";
                    applyFilter('ALL');
                    renderModalWordList();
                }
            });
        }

        window.addEventListener('DOMContentLoaded', initApp);
    </script>
</body>
</html>
