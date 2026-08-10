// ===== TERMINAL BRUTALIST INTERACTIONS =====

// Boot sequence + loader (skipped on repeat visits)
document.addEventListener('DOMContentLoaded', function() {
    const loader = document.getElementById('loader');
    const body = document.body;

    initNavigation();
    initMobileNav();
    initScrollEffects();
    initTabs();
    initCodeAnimations();
    initKeyboardShortcuts();
    initFAQ();

    if (sessionStorage.getItem('bm-visited')) {
        loader.classList.add('hidden');
        body.classList.remove('loading');
        initGSAPAnimations();
    } else {
        sessionStorage.setItem('bm-visited', '1');
        setTimeout(() => {
            loader.classList.add('hidden');
            body.classList.remove('loading');
            initGSAPAnimations();
        }, 2500);
    }
});

// Navigation with smooth scroll and active states
function initNavigation() {
    const nav = document.getElementById('nav');
    const navLinks = document.querySelectorAll('.nav-links a[href^="#"]');

    window.addEventListener('scroll', function() {
        if (window.scrollY > 50) {
            nav.classList.add('scrolled');
        } else {
            nav.classList.remove('scrolled');
        }

        updateActiveSection();
    });

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

// Mobile hamburger navigation
function initMobileNav() {
    const toggle = document.getElementById('navToggle');
    const links = document.getElementById('navLinks');
    if (!toggle || !links) return;

    toggle.addEventListener('click', () => {
        const open = links.classList.toggle('open');
        toggle.setAttribute('aria-expanded', String(open));
    });

    links.addEventListener('click', (e) => {
        if (e.target.tagName === 'A') {
            links.classList.remove('open');
            toggle.setAttribute('aria-expanded', 'false');
        }
    });

    document.addEventListener('keydown', (e) => {
        if (e.key === 'Escape' && links.classList.contains('open')) {
            links.classList.remove('open');
            toggle.setAttribute('aria-expanded', 'false');
        }
    });

    window.addEventListener('resize', () => {
        if (window.innerWidth > 480 && links.classList.contains('open')) {
            links.classList.remove('open');
            toggle.setAttribute('aria-expanded', 'false');
        }
    });
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

    if (icon) {
        icon.style.transform = 'scale(0) rotate(180deg)';
        icon.style.transition = 'transform 0.5s ease 0.2s';
        setTimeout(() => {
            icon.style.transform = 'scale(1) rotate(0deg)';
        }, 100);
    }

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

    lines.forEach((line, index) => {
        line.style.animationDelay = `${index * 100}ms`;
    });

    outputBlocks.forEach((block, index) => {
        block.style.animationDelay = `${(lines.length + index) * 100}ms`;
    });
}

// Download terminal animation - disabled for static display
function animateDownloadTerminal(terminal) {
    const lines = terminal.querySelectorAll('.terminal-line');
    const outputBlocks = terminal.querySelectorAll('.output-block, .terminal-line.success');

    lines.forEach((line, index) => {
        line.style.animationDelay = `${index * 100}ms`;
    });

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

            tabButtons.forEach(btn => btn.classList.remove('active'));
            tabPanes.forEach(pane => pane.classList.remove('active'));

            this.classList.add('active');
            const targetPane = document.getElementById(targetTab);
            if (targetPane) {
                targetPane.classList.add('active');

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
        const activeElement = document.activeElement;
        const isTyping = activeElement.tagName === 'INPUT'
            || activeElement.tagName === 'TEXTAREA'
            || activeElement.tagName === 'BUTTON';

        if (isTyping || e.ctrlKey || e.metaKey) return;

        // Press 'g' to go to GitHub
        if (e.key === 'g') {
            window.open('https://github.com/hasinhayder/bookmark.py', '_blank');
        }

        // Press 'Enter' to quick install
        if (e.key === 'Enter') {
            const installSection = document.getElementById('install');
            if (installSection) {
                installSection.scrollIntoView({ behavior: 'smooth' });
            }
        }

        // Press 'h' to go to hero
        if (e.key === 'h') {
            const hero = document.getElementById('hero');
            if (hero) {
                hero.scrollIntoView({ behavior: 'smooth' });
            }
        }
    });
}

// FAQ Section Functionality
function initFAQ() {
    const faqItems = document.querySelectorAll('.faq-item');
    const faqQuestions = document.querySelectorAll('.faq-question');

    faqQuestions.forEach((question) => {
        question.addEventListener('click', (e) => {
            e.preventDefault();
            const item = question.closest('.faq-item');

            faqItems.forEach((otherItem) => {
                if (otherItem !== item) {
                    otherItem.classList.remove('active');
                    const q = otherItem.querySelector('.faq-question');
                    if (q) q.setAttribute('aria-expanded', 'false');
                }
            });

            const open = item.classList.toggle('active');
            question.setAttribute('aria-expanded', String(open));
        });
    });

    if (typeof gsap === 'undefined') return;

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

// Add glitch effect to random terminals
function addGlitchEffect() {
    const terminals = document.querySelectorAll('.mini-terminal, .install-terminal, .download-terminal');

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

// Copy functionality for code blocks
document.addEventListener('DOMContentLoaded', function() {
    const codeBlocks = document.querySelectorAll('.code-content, .feature-code');

    codeBlocks.forEach(block => {
        block.style.cursor = 'pointer';
        block.title = 'Click to copy';

        block.addEventListener('click', async function() {
            const code = this.textContent || this.innerText;

            try {
                await navigator.clipboard.writeText(code);

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

// ===== GSAP ANIMATIONS =====
function initGSAPAnimations() {
    if (typeof gsap === 'undefined' || typeof ScrollTrigger === 'undefined') return;

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
    const terminals = document.querySelectorAll('.mini-terminal, .install-terminal, .download-terminal');

    if (terminals.length === 0) return;

    terminals.forEach(terminal => {
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
    if (typeof gsap === 'undefined') return;

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
}

// Initialize GSAP hover effects after GSAP animations are loaded
document.addEventListener('DOMContentLoaded', function() {
    setTimeout(() => {
        addGSAPHoverEffects();
    }, 3000);
});
