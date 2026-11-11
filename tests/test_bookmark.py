"""Tests for the non-interactive (piped stdin) selection path of bookmark.py.

Choosing ``0`` means "exit without selecting": it must resolve to ``None``
and print nothing on stdout, because callers print any truthy result as a
directory path for shell consumption (see ``list_bookmarks``,
``go_bookmark`` and the ``goto`` shell function).
"""

import importlib.util
import io
import sys
from pathlib import Path

import pytest

REPO_ROOT = Path(__file__).resolve().parent.parent


def load_bookmark_module():
    spec = importlib.util.spec_from_file_location(
        "bookmark_under_test", REPO_ROOT / "bookmark.py"
    )
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


@pytest.fixture()
def manager(tmp_path):
    bookmark = load_bookmark_module()
    mgr = bookmark.BookmarkManager()
    mgr.bookmark_file = tmp_path / "dir-bookmarks.txt"
    mgr.current_dir = str(tmp_path)
    return mgr


def _select(manager, text):
    manager_module_stdin = sys.stdin
    sys.stdin = io.StringIO(text)
    try:
        return manager._get_user_selection(
            [("proj", "/tmp/proj"), ("docs", "/tmp/docs")]
        )
    finally:
        sys.stdin = manager_module_stdin


def test_exit_choice_returns_none_and_prints_nothing(manager, capsys):
    assert _select(manager, "0\n") is None
    out, _ = capsys.readouterr()
    assert out == ""


def test_valid_choice_returns_path(manager, capsys):
    assert _select(manager, "2\n") == "/tmp/docs"
    out, _ = capsys.readouterr()
    assert out == ""


def test_out_of_range_choice_returns_none(manager, capsys):
    assert _select(manager, "9\n") is None
    out, _ = capsys.readouterr()
    assert out == ""
