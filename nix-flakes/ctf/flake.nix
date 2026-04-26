{
  description = "CTF Challenge Environment — Forensics + Python";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };

        # Python with common CTF libraries
        pythonEnv = pkgs.python3.withPackages (ps: with ps; [
          # Crypto & encoding
          pycryptodome
          pyopenssl
          gmpy2

          # Binary / reversing
          pwntools
          capstone

          # Network
          scapy
          requests
          pycurl

          # Data / misc
          pillow
          numpy
          opencv4
          opencv-python
          z3-solver
          sympy
          tqdm
          ipython
        ]);

      in
      {
        devShells.default = pkgs.mkShell {
          name = "ctf-env";

          packages = with pkgs; [
            # ── Shell ──────────────────────────────────────────────────────
            fish

            # ── Python ────────────────────────────────────────────────────
            pythonEnv

            # ── Forensics: file analysis ───────────────────────────────────
            file
            binwalk
            foremost
            sleuthkit       # autopsy CLI / disk forensics
            testdisk        # PhotoRec + TestDisk
            dcfldd          # forensic dd
            afflib          # AFF disk image support

            # ── Forensics: steganography ───────────────────────────────────
            steghide
            stegseek        # fast steghide bruteforce
            zsteg           # PNG/BMP steg detection
            exiftool        # EXIF metadata
            imagemagick     # image manipulation
            evtx

            # ── Forensics: memory ──────────────────────────────────────────
            volatility3

            # ── Forensics: network / pcap ──────────────────────────────────
            wireshark-cli   # tshark, capinfos, editcap, mergecap
            aircrack-ng
            wireshark
            tcpdump
            nmap
            netcat-gnu
            socat
            curl
            wget

            # ── Crypto / hashing ──────────────────────────────────────────
            openssl
            hashcat
            john             # John the Ripper
            fcrackzip

            # ── Binary / reversing ────────────────────────────────────────
            gdb
            gef              # GDB Enhanced Features plugin
            radare2
            ghidra
            patchelf
            ltrace
            strace
            binutils         # includes objdump, nm, strings, etc.

            # ── Web ───────────────────────────────────────────────────────
            httpie
            sqlmap
            dirb

            # ── Encoding / data wrangling ─────────────────────────────────
            xxd
            hexedit
            jq
            yq-go
            xz
            p7zip
            unrar
            cabextract

            # ── Misc utilities ────────────────────────────────────────────
            tmux
            ripgrep
            fd
            bat
            htop
            tree
            git
          ];

          # Drop straight into fish
          shellHook = ''
            export SHELL="${pkgs.fish}/bin/fish"
            export CTF_ENV=1

            # Friendly banner
            echo ""
            echo "  🚩  CTF Environment Ready"
            echo "  python  : $(python3 --version)"
            echo "  radare2 : $(r2 -v 2>/dev/null | head -1)"
            echo "  gdb     : $(gdb --version | head -1)"
            echo ""

            exec ${pkgs.fish}/bin/fish
          '';
        };
      }
    );
}
