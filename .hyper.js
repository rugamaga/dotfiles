module.exports = {
  config: {
    updateChannel: 'stable',
    fontSize: 18,
    fontFamily: 'Cica, Menlo, monospace',
    uiFontFamily: 'Cica, Menlo, monospace',
    fontWeight: 'normal',
    fontWeightBold: 'bold',
    cursorColor: 'rgba(248,28,229,0.8)',
    cursorAccentColor: '#000',
    cursorShape: 'BLOCK',
    cursorBlink: false,
    foregroundColor: '#FFFFFF',
    selectionColor: 'rgba(248,28,229,0.3)',
    borderColor: '#333333',
    showWindowControls: '',
    padding: '12px 14px',

    shell: '',
    shellArgs: ['--login'],
    env: {
      LANG: "ja_JP.UTF-8",
      LC_ALL: "ja_JP.UTF-8"
    },
    bell: false,
    copyOnSelect: false,
    defaultSSHApp: true,

    hyperTransparent: {
      backgroundColor: 'rgba(0, 0, 0, 0.75)',
      opacity: 0.75,
      vibrancy: ''
    },
  },

  plugins: [
    'hyperterm-1password',
    'hyper-snazzy',
    'hyper-transparent'
  ],

  localPlugins: [],

  keymaps: {
  },
};
