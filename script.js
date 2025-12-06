// ===== TERMINAL BRUTALIST INTERACTIONS =====

// Enhanced Terminal Loader
document.addEventListener('DOMContentLoaded', function() {
    const loader = document.getElementById('loader');
    const body = document.body;

    // Simulate terminal boot sequence
    setTimeout(() => {
        loader.classList.add('hidden');
        body.classList.remove('loading');

        // Initialize enhanced hero interactions
        initEnhancedTerminal();
        initMatrixRain();
        initGSAPAnimations();
    }, 2500);

    // Initialize all interactions
    initNavigation();
    initTerminalTyping();
    initScrollEffects();
    initTabs();
    initCodeAnimations();
    initKeyboardShortcuts();
    initFAQ();
});

// Navigation with smooth scroll and active states
function initNavigation() {
    const nav = document.getElementById('nav');
    const navLinks = document.querySelectorAll('.nav-links a[href^="#"]');

    // Handle scroll events for navbar
    window.addEventListener('scroll', function() {
        if (window.scrollY > 50) {
            nav.classList.add('scrolled');
        } else {
            nav.classList.remove('scrolled');
        }

        // Update active navigation based on scroll position
        updateActiveSection();
    });

    // Smooth scroll for navigation links
    navLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            const targetId = this.getAttribute('href');
            const targetSection = document.querySelector(targetId);

            if (targetSection) {
                targetSection.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        });
    });

    function updateActiveSection() {
        const sections = document.querySelectorAll('section[id]');
        const scrollPos = window.scrollY + 100;

        sections.forEach(section => {
            const top = section.offsetTop;
            const height = section.offsetHeight;
            const id = section.getAttribute('id');
            const activeLink = document.querySelector(`.nav-links a[href="#${id}"]`);

            if (scrollPos >= top && scrollPos < top + height) {
                navLinks.forEach(link => link.classList.remove('active'));
                if (activeLink) activeLink.classList.add('active');
            }
        });
    }
}

// Terminal typing animations
function initTerminalTyping() {
    // Animate hero terminal lines
    const terminalLines = document.querySelectorAll('.terminal-line');

    terminalLines.forEach((line, index) => {
        const userInputs = line.querySelectorAll('.user-input');

        userInputs.forEach(input => {
            const text = input.textContent;
            input.textContent = '';

            // Delay typing animation based on line index
            setTimeout(() => {
                typeText(input, text, 50);
            }, 1000 + (index * 500));
        });
    });

    function typeText(element, text, speed) {
        let i = 0;
        element.textContent = '';

        const timer = setInterval(() => {
            if (i < text.length) {
                element.textContent += text.charAt(i);
                i++;
            } else {
                clearInterval(timer);
                // Add blink cursor after typing
                const cursor = element.nextElementSibling;
                if (cursor && cursor.classList.contains('cursor')) {
                    cursor.style.display = 'inline-block';
                }
            }
        }, speed);
    }
}

// Scroll-triggered animations
function initScrollEffects() {
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };

    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');

                // Special animations for specific elements
                if (entry.target.classList.contains('feature-card')) {
                    animateFeatureCard(entry.target);
                } else if (entry.target.classList.contains('install-terminal')) {
                    animateInstallTerminal(entry.target);
                } else if (entry.target.classList.contains('download-terminal')) {
                    animateDownloadTerminal(entry.target);
                }
            }
        });
    }, observerOptions);

    // Observe elements for scroll animations
    const animatedElements = document.querySelectorAll(
        '.feature-card, .install-terminal, .download-terminal, .table-row'
    );

    animatedElements.forEach(el => {
        el.style.opacity = '0';
        el.style.transform = 'translateY(30px)';
        el.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
        observer.observe(el);
    });
}

// Feature card animations
function animateFeatureCard(card) {
    const icon = card.querySelector('.card-icon');
    const code = card.querySelector('.feature-code');

    // Animate icon
    if (icon) {
        icon.style.transform = 'scale(0) rotate(180deg)';
        icon.style.transition = 'transform 0.5s ease 0.2s';
        setTimeout(() => {
            icon.style.transform = 'scale(1) rotate(0deg)';
        }, 100);
    }

    // Animate code block
    if (code) {
        const codeText = code.querySelector('code');
        const text = codeText.textContent;
        codeText.textContent = '';

        setTimeout(() => {
            typeCode(codeText, text, 20);
        }, 500);
    }
}

// Terminal code typing animation
function typeCode(element, text, speed) {
    const lines = text.split('\n');
    let lineIndex = 0;
    let charIndex = 0;

    function typeLine() {
        if (lineIndex < lines.length) {
            if (charIndex === 0) {
                element.textContent += (lineIndex > 0 ? '\n' : '');
            }

            if (charIndex < lines[lineIndex].length) {
                element.textContent += lines[lineIndex][charIndex];
                charIndex++;
                setTimeout(typeLine, speed);
            } else {
                lineIndex++;
                charIndex = 0;
                setTimeout(typeLine, speed * 10);
            }
        }
    }

    typeLine();
}

// Installation terminal animation - disabled for static display
function animateInstallTerminal(terminal) {
    const lines = terminal.querySelectorAll('.terminal-line');
    const outputBlocks = terminal.querySelectorAll('.output-block');

    // Simply fade in the lines without clearing content
    lines.forEach((line, index) => {
        line.style.animationDelay = `${index * 100}ms`;
    });

    // Fade in output blocks
    outputBlocks.forEach((block, index) => {
        block.style.animationDelay = `${(lines.length + index) * 100}ms`;
    });
}

// Download terminal animation - disabled for static display
function animateDownloadTerminal(terminal) {
    const lines = terminal.querySelectorAll('.terminal-line');
    const outputBlocks = terminal.querySelectorAll('.output-block, .terminal-line.success');

    // Simply fade in the lines without clearing content
    lines.forEach((line, index) => {
        line.style.animationDelay = `${index * 100}ms`;
    });

    // Fade in output blocks and success messages
    if (outputBlocks) {
        outputBlocks.forEach((block, index) => {
            block.style.animationDelay = `${(lines.length + index) * 100}ms`;
        });
    }
}

// Tab functionality for usage section
function initTabs() {
    const tabButtons = document.querySelectorAll('.tab-btn');
    const tabPanes = document.querySelectorAll('.tab-pane');

    tabButtons.forEach(button => {
        button.addEventListener('click', function() {
            const targetTab = this.getAttribute('data-tab');

            // Remove active classes
            tabButtons.forEach(btn => btn.classList.remove('active'));
            tabPanes.forEach(pane => pane.classList.remove('active'));

            // Add active classes
            this.classList.add('active');
            const targetPane = document.getElementById(targetTab);
            if (targetPane) {
                targetPane.classList.add('active');

                // Animate code content
                const codeContent = targetPane.querySelector('.code-content code');
                if (codeContent) {
                    codeContent.style.opacity = '0';
                    setTimeout(() => {
                        codeContent.style.transition = 'opacity 0.3s ease';
                        codeContent.style.opacity = '1';
                    }, 100);
                }
            }
        });
    });
}

// Code window animations
function initCodeAnimations() {
    const codeWindows = document.querySelectorAll('.code-window');

    codeWindows.forEach(window => {
        const header = window.querySelector('.window-header');
        const content = window.querySelector('.code-content');

        window.addEventListener('mouseenter', function() {
            header.style.background = 'var(--terminal-bg)';
            content.style.background = 'var(--terminal-surface)';
        });

        window.addEventListener('mouseleave', function() {
            header.style.background = 'var(--terminal-surface)';
            content.style.background = 'var(--terminal-bg)';
        });
    });

    // Add hover effects to table rows
    const tableRows = document.querySelectorAll('.table-row:not(.header)');

    tableRows.forEach(row => {
        row.addEventListener('mouseenter', function() {
            const command = this.querySelector('.col-command code');
            if (command) {
                command.style.background = 'var(--primary)';
                command.style.color = 'var(--terminal-bg)';
            }
        });

        row.addEventListener('mouseleave', function() {
            const command = this.querySelector('.col-command code');
            if (command) {
                command.style.background = 'var(--terminal-bg)';
                command.style.color = 'var(--primary)';
            }
        });
    });
}

// Keyboard shortcuts
function initKeyboardShortcuts() {
    document.addEventListener('keydown', function(e) {
        // Press 'g' to go to GitHub
        if (e.key === 'g' && !e.ctrlKey && !e.metaKey) {
            const activeElement = document.activeElement;
            if (activeElement.tagName !== 'INPUT' && activeElement.tagName !== 'TEXTAREA') {
                window.open('https://github.com/hasinhayder/bookomark.py', '_blank');
            }
        }

        // Press 'Enter' to quick install
        if (e.key === 'Enter' && !e.ctrlKey && !e.metaKey) {
            const activeElement = document.activeElement;
            if (activeElement.tagName !== 'INPUT' && activeElement.tagName !== 'TEXTAREA') {
                const installSection = document.getElementById('install');
                if (installSection) {
                    installSection.scrollIntoView({ behavior: 'smooth' });
                }
            }
        }

        // Press 'h' to go to hero
        if (e.key === 'h' && !e.ctrlKey && !e.metaKey) {
            const activeElement = document.activeElement;
            if (activeElement.tagName !== 'INPUT' && activeElement.tagName !== 'TEXTAREA') {
                const hero = document.getElementById('hero');
                if (hero) {
                    hero.scrollIntoView({ behavior: 'smooth' });
                }
            }
        }

        // Press 'd' to restart demo
        if (e.key === 'd' && !e.ctrlKey && !e.metaKey) {
            const activeElement = document.activeElement;
            if (activeElement.tagName !== 'INPUT' && activeElement.tagName !== 'TEXTAREA') {
                restartTerminalDemo();
            }
        }
    });
}

// FAQ Section Functionality
function initFAQ() {
    const faqItems = document.querySelectorAll('.faq-item');

    // Add click event to each FAQ item
    faqItems.forEach((item) => {
        item.addEventListener('click', (e) => {
            // Prevent any default behavior
            e.preventDefault();

            // Close all other FAQ items
            faqItems.forEach((otherItem) => {
                if (otherItem !== item) {
                    otherItem.classList.remove('active');
                }
            });

            // Toggle current item
            item.classList.toggle('active');
        });
    });

    // Initial animation for FAQ items
    gsap.fromTo(faqItems,
        {
            y: 50,
            opacity: 0,
            scale: 0.95
        },
        {
            y: 0,
            opacity: 1,
            scale: 1,
            duration: 0.6,
            stagger: 0.1,
            ease: "power2.out",
            scrollTrigger: {
                trigger: ".faq",
                start: "top 80%"
            }
        }
    );

    // Animate FAQ icons on hover
    faqItems.forEach(item => {
        const icon = item.querySelector('.faq-icon');

        item.addEventListener('mouseenter', () => {
            if (icon) {
                gsap.to(icon, {
                    rotation: 10,
                    scale: 1.1,
                    duration: 0.3,
                    ease: "power2.out"
                });
            }
        });

        item.addEventListener('mouseleave', () => {
            if (icon) {
                gsap.to(icon, {
                    rotation: 0,
                    scale: 1,
                    duration: 0.3,
                    ease: "power2.out"
                });
            }
        });
    });
}

// Enhanced Terminal Interactions
function initEnhancedTerminal() {
    const terminalLines = document.querySelectorAll('.terminal-line');
    const outputBlocks = document.querySelectorAll('.output-block');
    const interactiveMenu = document.querySelector('.interactive-menu');

    // Animate terminal lines with delays
    terminalLines.forEach((line, index) => {
        const lineNumber = line.dataset.line;
        const delay = (parseInt(lineNumber) - 1) * 800;

        line.style.animationDelay = `${delay}ms`;

        // Add typing animation to commands
        const command = line.querySelector('[data-typing]');
        if (command) {
            const text = command.textContent;
            command.textContent = '';
            setTimeout(() => {
                typeText(command, text, 50);
            }, delay + 500);
        }
    });

    // Animate output blocks
    outputBlocks.forEach(block => {
        const delay = block.dataset.delay || 500;
        block.style.animationDelay = `${delay}ms`;
    });

    // Animate interactive menu
    if (interactiveMenu) {
        const delay = interactiveMenu.dataset.delay || 4500;
        interactiveMenu.style.animationDelay = `${delay}ms`;

        // Animate menu selection
        setTimeout(() => {
            animateMenuSelection();
        }, parseInt(delay) + 500);
    }
}

// Matrix Rain Background
function initMatrixRain() {
    const matrixBg = document.getElementById('matrixBg');
    if (!matrixBg) return;

    const canvas = document.createElement('canvas');
    canvas.width = window.innerWidth;
    canvas.height = window.innerHeight;
    matrixBg.appendChild(canvas);

    const ctx = canvas.getContext('2d');
    const matrix = '01';
    const fontSize = 14;
    const columns = canvas.width / fontSize;
    const drops = [];

    for (let i = 0; i < columns; i++) {
        drops[i] = Math.random() * -100;
    }

    function draw() {
        ctx.fillStyle = 'rgba(0, 0, 0, 0.05)';
        ctx.fillRect(0, 0, canvas.width, canvas.height);

        ctx.fillStyle = '#00ff88';
        ctx.font = fontSize + 'px monospace';

        for (let i = 0; i < drops.length; i++) {
            const text = matrix[Math.floor(Math.random() * matrix.length)];
            ctx.fillText(text, i * fontSize, drops[i] * fontSize);

            if (drops[i] * fontSize > canvas.height && Math.random() > 0.975) {
                drops[i] = 0;
            }
            drops[i] += 0.5;
        }
    }

    const interval = setInterval(draw, 35);

    // Clear after some time
    setTimeout(() => {
        clearInterval(interval);
        matrixBg.innerHTML = '';
    }, 20000);

    // Handle resize
    window.addEventListener('resize', () => {
        canvas.width = window.innerWidth;
        canvas.height = window.innerHeight;
    });
}

// Demo Button
function initDemoButton() {
    // Removed as hero section has been simplified
}

// Restart Terminal Demo
function restartTerminalDemo() {
    const terminal = document.querySelector('.mini-terminal');

    if (!terminal) return;

    // Add glitch effect
    terminal.style.animation = 'glitch 0.3s ease';
    setTimeout(() => {
        terminal.style.animation = '';
    }, 300);

    setTimeout(() => {
        initEnhancedTerminal();
    }, 500);
}

// Animate Menu Selection
function animateMenuSelection() {
    const menuItems = document.querySelectorAll('.menu-item');
    const userInput = document.querySelector('.user-input[data-typing]');

    if (userInput) {
        const text = userInput.textContent;
        userInput.textContent = '';
        typeText(userInput, text, 100);
    }

    // Highlight selected item
    menuItems.forEach((item, index) => {
        if (item.dataset.id === '3') {
            setTimeout(() => {
                item.classList.add('highlight');
                // Scroll menu item into view
                item.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
            }, 1000 + (index * 200));
        }
    });
}

// Add glitch effect to random terminals
function addGlitchEffect() {
    const terminals = document.querySelectorAll('.terminal-window, .mini-terminal, .install-terminal, .download-terminal');

    if (terminals.length === 0) return;

    const randomTerminal = terminals[Math.floor(Math.random() * terminals.length)];

    if (randomTerminal) {
        randomTerminal.style.animation = 'glitch 0.3s ease';
        setTimeout(() => {
            randomTerminal.style.animation = '';
        }, 300);
    }
}

// Add glitch animation keyframe
const style = document.createElement('style');
style.textContent = `
    @keyframes glitch {
        0%, 100% { transform: translate(0); }
        20% { transform: translate(-2px, 2px); }
        40% { transform: translate(-2px, -2px); }
        60% { transform: translate(2px, 2px); }
        80% { transform: translate(2px, -2px); }
    }

    .animate-in {
        opacity: 1 !important;
        transform: translateY(0) !important;
    }
`;
document.head.appendChild(style);

// Randomly trigger glitch effect
setInterval(() => {
    if (Math.random() > 0.7) {
        addGlitchEffect();
    }
}, 10000);

// Add typing sound effect simulation (visual feedback)
function simulateTypingSound() {
    const terminals = document.querySelectorAll('.terminal-body');
    terminals.forEach(terminal => {
        terminal.addEventListener('click', function() {
            this.style.animation = 'typingPulse 0.2s ease';
            setTimeout(() => {
                this.style.animation = '';
            }, 200);
        });
    });
}

// Add typing pulse animation
const typingStyle = document.createElement('style');
typingStyle.textContent = `
    @keyframes typingPulse {
        0%, 100% { background: var(--terminal-bg); }
        50% { background: rgba(0, 255, 136, 0.05); }
    }
`;
document.head.appendChild(typingStyle);

simulateTypingSound();

// Add copy functionality to code blocks
document.addEventListener('DOMContentLoaded', function() {
    const codeBlocks = document.querySelectorAll('.code-content, .feature-code, .terminal-body');

    codeBlocks.forEach(block => {
        block.style.cursor = 'pointer';
        block.title = 'Click to copy';

        block.addEventListener('click', async function() {
            const code = this.textContent || this.innerText;

            try {
                await navigator.clipboard.writeText(code);

                // Visual feedback
                const originalBg = this.style.background;
                this.style.background = 'rgba(0, 255, 136, 0.1)';
                this.title = 'Copied!';

                setTimeout(() => {
                    this.style.background = originalBg;
                    this.title = 'Click to copy';
                }, 1000);

            } catch (err) {
                console.error('Failed to copy code: ', err);
            }
        });
    });
});

// Add matrix rain effect to background occasionally
function createMatrixRain() {
    const canvas = document.createElement('canvas');
    canvas.style.position = 'fixed';
    canvas.style.top = '0';
    canvas.style.left = '0';
    canvas.style.width = '100%';
    canvas.style.height = '100%';
    canvas.style.pointerEvents = 'none';
    canvas.style.opacity = '0.05';
    canvas.style.zIndex = '0';

    const ctx = canvas.getContext('2d');
    canvas.width = window.innerWidth;
    canvas.height = window.innerHeight;

    const matrix = '01';
    const fontSize = 14;
    const columns = canvas.width / fontSize;
    const drops = [];

    for (let i = 0; i < columns; i++) {
        drops[i] = 1;
    }

    function draw() {
        ctx.fillStyle = 'rgba(0, 0, 0, 0.05)';
        ctx.fillRect(0, 0, canvas.width, canvas.height);

        ctx.fillStyle = '#00ff88';
        ctx.font = fontSize + 'px monospace';

        for (let i = 0; i < drops.length; i++) {
            const text = matrix[Math.floor(Math.random() * matrix.length)];
            ctx.fillText(text, i * fontSize, drops[i] * fontSize);

            if (drops[i] * fontSize > canvas.height && Math.random() > 0.975) {
                drops[i] = 0;
            }
            drops[i]++;
        }
    }

    document.body.appendChild(canvas);

    const interval = setInterval(draw, 35);

    // Remove after 3 seconds
    setTimeout(() => {
        clearInterval(interval);
        canvas.remove();
    }, 3000);
}

// Trigger matrix rain on page load
setTimeout(() => {
    createMatrixRain();
}, 3000);

// Parallax effect for hero terminal
window.addEventListener('scroll', function() {
    const heroTerminal = document.querySelector('.mini-terminal');
    const scrolled = window.pageYOffset;

    if (heroTerminal && scrolled < window.innerHeight) {
        const speed = 0.5;
        heroTerminal.style.transform = `translateY(${scrolled * speed}px) perspective(1000px) rotateX(2deg)`;
    }
});

// Add hover sound effect (visual simulation)
function addHoverSound(element) {
    element.addEventListener('mouseenter', function() {
        this.style.transition = 'all 0.1s ease';
        this.style.transform = 'scale(1.02)';
    });

    element.addEventListener('mouseleave', function() {
        this.style.transform = 'scale(1)';
    });
}

// Apply hover sound to interactive elements
document.addEventListener('DOMContentLoaded', function() {
    const interactiveElements = document.querySelectorAll('.action-btn, .download-btn, .tab-btn, .feature-card');
    interactiveElements.forEach(addHoverSound);
});

// ===== GSAP ANIMATIONS =====
function initGSAPAnimations() {
    // Register ScrollTrigger plugin
    gsap.registerPlugin(ScrollTrigger);

    // Hero section entrance animations
    animateHeroSection();

    // Feature cards staggered animation
    animateFeatureCards();

    // Terminal animations on scroll
    animateTerminalsOnScroll();

    // Download buttons animation
    animateDownloadSection();

    // Navigation scroll effects
    enhanceNavigation();

    // Parallax effects
    addParallaxEffects();

    // Terminal glitches
    addTerminalGlitches();
}

function animateHeroSection() {
    // Hero title animation
    const heroTitle = document.querySelector('.hero-title');
    if (heroTitle) {
        const titleHighlight = heroTitle.querySelector('.title-highlight');

        if (titleHighlight) {
            gsap.fromTo(heroTitle,
                {
                    y: 100,
                    opacity: 0
                },
                {
                    y: 0,
                    opacity: 1,
                    duration: 1.2,
                    ease: "power3.out"
                }
            );

            gsap.fromTo(titleHighlight,
                {
                    scale: 0.8,
                    opacity: 0
                },
                {
                    scale: 1,
                    opacity: 1,
                    duration: 0.8,
                    delay: 0.6,
                    ease: "back.out(1.7)"
                }
            );
        }
    }

    // Hero subtitle fade in
    const heroSubtitle = document.querySelector('.hero-subtitle');
    if (heroSubtitle) {
        gsap.fromTo(heroSubtitle,
            {
                y: 50,
                opacity: 0
            },
            {
                y: 0,
                opacity: 1,
                duration: 1,
                delay: 0.8,
                ease: "power2.out"
            }
        );
    }

  
    // Hero visual terminal
    const heroVisual = document.querySelector('.hero-visual');
    if (heroVisual) {
        gsap.fromTo(heroVisual,
            {
                x: 100,
                opacity: 0
            },
            {
                x: 0,
                opacity: 1,
                duration: 1,
                delay: 1.5,
                ease: "power2.out"
            }
        );
    }
}

function animateFeatureCards() {
    const featureCards = document.querySelectorAll('.feature-card');

    gsap.fromTo(featureCards,
        {
            y: 80,
            opacity: 0,
            scale: 0.8
        },
        {
            y: 0,
            opacity: 1,
            scale: 1,
            duration: 0.8,
            stagger: 0.2,
            ease: "power2.out",
            scrollTrigger: {
                trigger: ".features",
                start: "top 80%"
            }
        }
    );

    // Feature icons animation
    featureCards.forEach((card, index) => {
        const icon = card.querySelector('.card-icon');
        if (icon) {
            gsap.fromTo(icon,
                {
                    rotation: 360,
                    scale: 0,
                    opacity: 0
                },
                {
                    rotation: 0,
                    scale: 1,
                    opacity: 1,
                    duration: 0.6,
                    delay: 0.3 + (index * 0.1),
                    ease: "back.out(1.7)",
                    scrollTrigger: {
                        trigger: card,
                        start: "top 85%"
                    }
                }
            );
        }
    });
}

function animateTerminalsOnScroll() {
    // Installation terminal
    const installTerminal = document.querySelector('.install-terminal');
    if (installTerminal) {
        gsap.fromTo(installTerminal,
            {
                x: -100,
                opacity: 0,
                rotation: 2
            },
            {
                x: 0,
                opacity: 1,
                rotation: 0,
                duration: 1,
                ease: "power2.out",
                scrollTrigger: {
                    trigger: installTerminal,
                    start: "top 75%"
                }
            }
        );
    }

    // Usage section terminal
    const usageSection = document.querySelector('.usage');
    if (usageSection) {
        const codeWindows = usageSection.querySelectorAll('.code-window');
        gsap.fromTo(codeWindows,
            {
                x: 100,
                opacity: 0,
                rotation: -2
            },
            {
                x: 0,
                opacity: 1,
                rotation: 0,
                duration: 1,
                stagger: 0.3,
                ease: "power2.out",
                scrollTrigger: {
                    trigger: usageSection,
                    start: "top 75%"
                }
            }
        );
    }

    // Commands table
    const tableRows = document.querySelectorAll('.table-row:not(.header)');
    gsap.fromTo(tableRows,
        {
            x: -50,
            opacity: 0
        },
        {
            x: 0,
            opacity: 1,
            duration: 0.6,
            stagger: 0.1,
            ease: "power2.out",
            scrollTrigger: {
                trigger: ".commands-table",
                start: "top 80%"
            }
        }
    );

    // Download terminal
    const downloadTerminal = document.querySelector('.download-terminal');
    if (downloadTerminal) {
        gsap.fromTo(downloadTerminal,
            {
                y: 100,
                opacity: 0,
                scale: 0.9
            },
            {
                y: 0,
                opacity: 1,
                scale: 1,
                duration: 1,
                ease: "power2.out",
                scrollTrigger: {
                    trigger: downloadTerminal,
                    start: "top 80%"
                }
            }
        );
    }
}

function animateDownloadSection() {
    const downloadBtns = document.querySelectorAll('.download-btn');

    gsap.fromTo(downloadBtns,
        {
            y: 50,
            opacity: 0,
            scale: 0.8
        },
        {
            y: 0,
            opacity: 1,
            scale: 1,
            duration: 0.8,
            stagger: 0.2,
            delay: 0.5,
            ease: "elastic.out(1, 0.5)",
            scrollTrigger: {
                trigger: ".download-buttons",
                start: "top 85%"
            }
        }
    );

    // Terminal shortcuts
    const shortcuts = document.querySelectorAll('.shortcut');
    gsap.fromTo(shortcuts,
        {
            x: -30,
            opacity: 0
        },
        {
            x: 0,
            opacity: 1,
            duration: 0.6,
            stagger: 0.1,
            delay: 0.8,
            ease: "power2.out",
            scrollTrigger: {
                trigger: ".terminal-shortcuts",
                start: "top 85%"
            }
        }
    );
}

function enhanceNavigation() {
    // Navigation background animation on scroll
    gsap.to("#nav", {
        backgroundColor: "rgba(0, 0, 0, 0.95)",
        backdropFilter: "blur(20px)",
        duration: 0.3,
        scrollTrigger: {
            trigger: "body",
            start: "50px",
            end: "51px",
            scrub: true
        }
    });
}

function addParallaxEffects() {
    // Hero terminal parallax
    const heroTerminal = document.querySelector('.mini-terminal');
    if (heroTerminal) {
        gsap.to(heroTerminal, {
            yPercent: -30,
            ease: "none",
            scrollTrigger: {
                trigger: heroTerminal,
                start: "top top",
                end: "bottom top",
                scrub: true
            }
        });
    }

    // Section titles parallax
    const sectionTitles = document.querySelectorAll('.section-title');
    sectionTitles.forEach(title => {
        gsap.to(title, {
            yPercent: -20,
            ease: "none",
            scrollTrigger: {
                trigger: title,
                start: "top bottom",
                end: "bottom top",
                scrub: true
            }
        });
    });
}

function addTerminalGlitches() {
    const terminals = document.querySelectorAll('.terminal-window, .mini-terminal, .install-terminal, .download-terminal');

    if (terminals.length === 0) return;

    terminals.forEach(terminal => {
        // Random glitch effect
        gsap.timeline({
            repeat: -1,
            repeatDelay: () => 5 + Math.random() * 10
        })
        .to(terminal, {
            x: () => Math.random() * 4 - 2,
            y: () => Math.random() * 4 - 2,
            duration: 0.05,
            ease: "none"
        })
        .to(terminal, {
            x: () => Math.random() * 4 - 2,
            y: () => Math.random() * 4 - 2,
            duration: 0.05,
            ease: "none"
        })
        .to(terminal, {
            x: 0,
            y: 0,
            duration: 0.05,
            ease: "none"
        });
    });

    // Typing cursor animation
    const cursors = document.querySelectorAll('.cursor');
    cursors.forEach(cursor => {
        gsap.to(cursor, {
            opacity: 0,
            duration: 0.5,
            repeat: -1,
            ease: "none",
            yoyo: true
        });
    });
}

// Enhanced hover effects with GSAP
function addGSAPHoverEffects() {
    // Download buttons
    const downloadBtns = document.querySelectorAll('.download-btn');
    downloadBtns.forEach(btn => {
        btn.addEventListener('mouseenter', function() {
            gsap.to(this, {
                scale: 1.05,
                duration: 0.3,
                ease: "power2.out"
            });
        });

        btn.addEventListener('mouseleave', function() {
            gsap.to(this, {
                scale: 1,
                duration: 0.3,
                ease: "power2.out"
            });
        });
    });

    // Feature cards
    const featureCards = document.querySelectorAll('.feature-card');
    featureCards.forEach(card => {
        card.addEventListener('mouseenter', function() {
            gsap.to(this, {
                y: -10,
                duration: 0.3,
                ease: "power2.out"
            });
        });

        card.addEventListener('mouseleave', function() {
            gsap.to(this, {
                y: 0,
                duration: 0.3,
                ease: "power2.out"
            });
        });
    });

    // Terminal windows
    const terminals = document.querySelectorAll('.terminal-window, .mini-terminal, .install-terminal, .download-terminal');
    if (terminals.length > 0) {
        terminals.forEach(terminal => {
        terminal.addEventListener('mouseenter', function() {
            gsap.to(this, {
                boxShadow: "0 20px 40px rgba(0, 255, 136, 0.3)",
                duration: 0.3,
                ease: "power2.out"
            });
        });

        terminal.addEventListener('mouseleave', function() {
            gsap.to(this, {
                boxShadow: "0 0 0 rgba(0, 255, 136, 0)",
                duration: 0.3,
                ease: "power2.out"
            });
        });
    });
    }
}

// Initialize GSAP hover effects after GSAP animations are loaded
document.addEventListener('DOMContentLoaded', function() {
    setTimeout(() => {
        addGSAPHoverEffects();
    }, 3000);
});